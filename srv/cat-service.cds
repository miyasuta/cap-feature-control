using my.bookshop as my from '../db/schema';

@requires: 'authenticated-user'
service CatalogService {
    @odata.draft.enabled
    entity Books as projection on my.Books
        actions {
            action updateStock(stock : Integer) returns Books; // bound action
        };

    //unbound action
    action autoFillStock();

    @odata.singleton
    entity FeatureControl {
        operationHidden : Boolean;
        operationEnabled : Boolean;
    }
}

// Enable / Disable operations
// // CRUD Operations
// annotate CatalogService.Books with @(
//     Capabilities.UpdateRestrictions: {
//         Updatable: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationEnabled' } }
//     },
//     Capabilities.DeleteRestrictions: {
//         Deletable: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationEnabled' } }
//     }
// );

// // Bound Action
// annotate CatalogService.Books with actions {
//     updateStock @(
//         Core.OperationAvailable: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationEnabled' } } 
//         // Core.OperationAvailable: { $edmJson: { $Not: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationHidden' } } } //this does not work
//     );
// };


// Hide / Show operations
// CRUD Operations
annotate CatalogService.Books with @(
    UI.CreateHidden: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationHidden' } }, //this works
    // UI.CreateHidden : { $edmJson: {$Not: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationEnabled'} } }, // this does not work
    UI.UpdateHidden: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationHidden' } },
    UI.DeleteHidden: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationHidden' } }
);

// Unbound Action
annotate CatalogService.autoFillStock with @(
    Core.OperationAvailable: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationEnabled' } } 
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
            ![@UI.Hidden]: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationHidden' }},
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.EntityContainer/autoFillStock',
            Label : 'Auto Fill Stock',
            ![@UI.Hidden]: { $edmJson: { $Path: '/CatalogService.EntityContainer/FeatureControl/operationHidden' }},
        },
    ],
);
