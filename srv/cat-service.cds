using my.bookshop as my from '../db/schema';

@requires: 'authenticated-user'
service CatalogService {
    @odata.draft.enabled
    entity Books as projection on my.Books
        actions {
            action updateStock(stock : Integer) returns Books;
        };

    //unbound action
    action autoFillStock();

    @odata.singleton
    entity FeatureControl {
        createHidden  : Boolean;
        createEnabled : Boolean;
        actionHidden : Boolean;
        actionEnabled : Boolean;
    }
}

annotate CatalogService.Books with @(
    // UI.CreateHidden: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/createHidden' } } this works
    UI.CreateHidden : { $edmJson: {$Not: { $Path: '/CatalogService.EntityContainer/FeatureControl/createEnabled'} } } // this does not work
);

// bound action
annotate CatalogService.Books with actions {
    updateStock @(
        Core.OperationAvailable: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/actionEnabled' } } 
        // Core.OperationAvailable: { $edmJson: { $Not: { $Path: '/CatalogService.EntityContainer/FeatureControl/actionHidden' } } } //this does not work
    );
};

// unbound action
annotate CatalogService.autoFillStock with @(
    Core.OperationAvailable: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/actionEnabled' } } 
);

annotate CatalogService.Books with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'ID',
                Value : ID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'title',
                Value : title,
            },
            {
                $Type : 'UI.DataField',
                Label : 'stock',
                Value : stock,
            }
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'ID',
            Value : ID,
        },
        {
            $Type : 'UI.DataField',
            Label : 'title',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Label : 'stock',
            Value : stock,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.updateStock',
            Label : 'Update Stock',
            ![@UI.Hidden]: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/actionHidden' }},
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.EntityContainer/autoFillStock',
            Label : 'Auto Fill Stock',
            ![@UI.Hidden]: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/actionHidden' }},
        },
    ],
);
