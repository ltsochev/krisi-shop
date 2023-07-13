<?php

/*
Plugin Name: Krisi Store Product List
Description: A plugin to display the last 4 products from each category in a WooCommerce shop.
Version: 1.0
Author: Lachezar Tsochev
Author URI: https://store.kristinakostova.com
*/

function kpl_load_categories_with_products() {
    $args = array(
        'taxonomy' => 'product_cat',
        'hide_empty' => true,
        'number' => 4, // Adjust the number of categories to retrieve
        'pad_counts' => true,
    );

    $categories = get_terms($args);

    if (!empty($categories)) {
        $output = '<div class="krisi-product-list">';
        foreach ($categories as $category) {
            $products = wc_get_products(array(
                'category' => array($category->slug),
                'limit' => 4, // Retrieve 4 products per category
            ));

            if ($products) {
                $output .= generate_list($category, $products);
            }
        }
        $output .= '</div>';
        return $output;
    }
    return '';
}

function generate_list($category, $products) {
    ob_start();

    include(plugin_dir_path(__FILE__) . 'product.tpl.php');

    $html = ob_get_clean();

    return $html;
}

function kpl_register_block() {
    if (!function_exists('register_block_type')) {
        return;
    }

    wp_register_script(
        'krisi-product-list-block',
        plugins_url('kpl-block.js', __FILE__),
        array('wp-blocks', 'wp-element', 'wp-components'),
        filemtime(plugin_dir_path(__FILE__) . 'kpl-block.js')
    );

    register_block_type('krisi-product-list/product-list-block', array(
        'editor_script' => 'krisi-product-list-block',
        'render_callback' => 'kpl_load_categories_with_products',
    ));
}

function enqueue_custom_styles() {
    wp_enqueue_style(
        'kstore-cards-style',
        plugins_url('kstore-cards.css?v=' . time(), __FILE__),
        array(),
        '1.0'
    );
}

add_action('init', 'kpl_register_block');
  
add_action('wp_enqueue_scripts', 'enqueue_custom_styles');
