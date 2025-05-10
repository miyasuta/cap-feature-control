import cds from '@sap/cds'
import { Books, FeatureControl } from '#cds-models/CatalogService'

export class CatalogService extends cds.ApplicationService { init() {

  this.on ('READ', FeatureControl, async (req) => {
    return {
      isCreateEnabled: true,
      isActionEnabled: true
    }
  })


  return super.init()
}}
