import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FadeInImageWidget extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const FadeInImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<FadeInImageWidget> createState() => _FadeInImageWidgetState();
}

class _FadeInImageWidgetState extends State<FadeInImageWidget> {
  bool _hasError = false;
  bool _isLoading = true;
  ImageProvider? _imageProvider;

  ImageProvider _createImageProvider() {
    final networkImage = NetworkImage(
      widget.imageUrl,
      headers: const {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
      },
    );
    
    // Se abbiamo dimensioni specificate, usa ResizeImage per migliorare la qualità
    // Carica a 3x la risoluzione per immagini più nitide
    if (widget.width != null && widget.height != null && 
        widget.width!.isFinite && widget.height!.isFinite) {
      return ResizeImage(
        networkImage,
        width: (widget.width! * 3).toInt(),
        height: (widget.height! * 3).toInt(),
        allowUpscaling: true,
      );
    }
    
    return networkImage;
  }

  @override
  void initState() {
    super.initState();
    _hasError = false;
    _isLoading = true;
    _imageProvider = _createImageProvider();
  }

  @override
  void didUpdateWidget(FadeInImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se l'URL o le dimensioni cambiano, resetta lo stato e crea un nuovo provider
    if (oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height) {
      _imageProvider = _createImageProvider();
      // Posticipa setState dopo il frame corrente per evitare errori durante il build
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _hasError = false;
            _isLoading = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica che l'URL sia valido
    if (widget.imageUrl.isEmpty) {
      return widget.errorWidget ??
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          );
    }

    // Se c'è un errore, mostra l'error widget
    if (_hasError) {
      return widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
          );
    }
    
    // Usa una key basata sull'URL per evitare ricaricamenti inutili
    return TweenAnimationBuilder<double>(
      key: ValueKey('fade_${widget.imageUrl}'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Image(
        image: _imageProvider!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            if (mounted && _isLoading) {
              // Posticipa setState dopo il frame corrente per evitare errori durante il build
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              });
            }
            return child;
          }
          return widget.placeholder ??
              Container(
                width: widget.width,
                height: widget.height,
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) {
          if (mounted && (!_hasError || _isLoading)) {
            // Posticipa setState dopo il frame corrente per evitare errori durante il build
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                });
              }
            });
          }
          return widget.errorWidget ??
              Container(
                width: widget.width,
                height: widget.height,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              );
        },
        // Evita ricaricamenti quando il widget viene ricostruito
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return widget.placeholder ??
              Container(
                width: widget.width,
                height: widget.height,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
        },
      ),
    );
  }
}

