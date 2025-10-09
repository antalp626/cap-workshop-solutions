using my.bookshop as my from '../db/schema';
using { API_BUSINESS_PARTNER as external } from './external/API_BUSINESS_PARTNER';


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

    action approveBook(book : Books:title, author : Authors:name) returns {
        status: String;
        id: String
    }
}

service ExternalService {
    entity API_BP as projection on external.A_BusinessPartner{
        BusinessPartner,
        Customer,
        Supplier,
        AcademicTitle,
        AuthorizationGroup,
        BusinessPartnerCategory,
        BusinessPartnerFullName,
        BusinessPartnerGrouping,
        BusinessPartnerName
    };
}