using my.bookshop as my from '../db/schema';

service CatalogService {
    @readonly entity Books as projection on my.Books {
        *,
        author.name as author_name
    };
    @readonly entity Authors as projection on my.Authors;
}
