using my.bookshop as my from '../db/schema';

service CatalogService {
    @readonly entity Books as projection on my.Books {
            *,
            author.name as author_name
    };

    entity Authors as projection on my.Authors;

    function totalStock()                                     returns Integer;

    action   submitOrder(book : Books:ID, quantity : Integer) returns {
        stock : Integer
    };
}
