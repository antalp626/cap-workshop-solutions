using my.bookshop as my from '../db/schema';

@(requires: 'authenticated-user')
service CatalogService {
    entity Books 
    @(restrict : [
        {
            grant: ['READ'],
            to   : ['authenticated-user']
        },
        {
            grant: ['*'],
            to   : ['Admin']
        }
    ]) as
        projection on my.Books {
            *,
            author.name as author_name
        };

    entity Authors 
    @(restrict : [
          {
                grant : [ 'READ' ],
                to :    [ 'authenticated-user' ]
            },
            {
                grant : [ '*' ],
                to : [ 'Admin' ]
            }
     ])
    as projection on my.Authors;

    function totalStock()                                   returns Integer;

    action   submitOrder(book: Books:ID, quantity: Integer) returns {
        stock : Integer
    };
}
