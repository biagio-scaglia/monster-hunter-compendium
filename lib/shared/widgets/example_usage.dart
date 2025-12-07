// Questo file contiene esempi di utilizzo dei componenti UI modulari
// Non importare questo file nel codice di produzione

/*
ESEMPIO 1: GradientCard con animazione
=====================================

GradientCard(
  isRare: true, // Aggiunge glow effect per item rari
  onTap: () {
    // Navigazione o azione
  },
  child: Column(
    children: [
      Text('Titolo', style: AppTheme.cardTitleStyle),
      Text('Descrizione', style: AppTheme.cardBodyStyle),
    ],
  ),
)

ESEMPIO 2: ShimmerLoader per loading states
===========================================

if (isLoading)
  ShimmerList(itemCount: 5)
else
  // Contenuto reale

ESEMPIO 3: RareBadge per item rari
==================================

RareBadge(
  text: 'RARE',
  withGlow: true, // Aggiunge effetto glow
)

ESEMPIO 4: GradientButton con haptic feedback
=============================================

GradientButton(
  text: 'Clicca qui',
  icon: Icons.star,
  isFullWidth: true,
  onPressed: () {
    // Azione con haptic feedback automatico
  },
)

ESEMPIO 5: FadeInImageWidget per immagini con cache
===================================================

FadeInImageWidget(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)

ESEMPIO 6: SlidableListItem per azioni rapide
==============================================

SlidableListItem(
  actions: [
    SlidableActionButton(
      icon: Icons.favorite,
      label: 'Aggiungi',
      backgroundColor: AppTheme.successColor,
      onPressed: () {},
    ),
  ],
  secondaryActions: [
    SlidableActionButton(
      icon: Icons.delete,
      label: 'Elimina',
      backgroundColor: AppTheme.errorColor,
      onPressed: () {},
    ),
  ],
  onTap: () {
    // Navigazione
  },
  child: ListTile(
    title: Text('Item'),
  ),
)

ESEMPIO 7: GridView con GradientCard
===================================

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemBuilder: (context, index) {
    return GradientCard(
      isRare: items[index].isRare,
      child: // Contenuto card
    );
  },
)

ESEMPIO 8: RefreshIndicator con swipe-to-refresh
=================================================

RefreshIndicator(
  onRefresh: () async {
    await provider.refreshData();
  },
  child: ListView.builder(
    itemBuilder: (context, index) {
      return GradientCard(/* ... */);
    },
  ),
)
*/

