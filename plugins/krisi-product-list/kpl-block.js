(function (blocks, element, components) {
    'use strict';

    var el = element.createElement;
    var registerBlockType = blocks.registerBlockType;

    registerBlockType('krisi-product-list/product-list-block', {
        title: 'Krisi Product List',
        icon: 'category',
        category: 'common',
        edit: function (props) {
            return el('div', { className: props.className },
                el('p', null, 'Krisi Product List')
            );
        },
        save: function () {
            return null;
        }
    });
})(window.wp.blocks,
    window.wp.element,
    window.wp.components);
