<h2 class="wp-block-heading has-text-align-center kstore-heading"><?= $category->name; ?></h2>
<div class="category-product-list">
    <ul class="product-card-list">
    <?php foreach ($products as $product): ?>
        <li class="product-card-list-item">
            <a href="<?= $product->get_permalink(); ?>" class="product-card-list-item-mask" title="<?= $product->name; ?>">
                <span class="visibility-hidden"><?= $product->name; ?></span>
            </a>
            <div class="product-card__image-with-placeholder-wrapper">
                <?= $product->get_image(); ?>
            </div>
            <div class="h4 grid-view-item__title product-card__title"><?= $product->name; ?></div>
            <div class="product-car-price price--listing">
                <div class="price-regular"><?= $product->get_price_html(); ?></div>
            </div>
        </li>
    <?php endforeach; ?>
    </ul>
</div>