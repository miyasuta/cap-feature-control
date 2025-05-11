import cds from '@sap/cds'
import { Books, FeatureControl  } from '#cds-models/CatalogService'

export class CatalogService extends cds.ApplicationService { init() {

  this.on ('READ', FeatureControl, async (req) => {
    let createHidden = true, actionHidden = true

    if (req.user.is('Admin')) {
      createHidden = false
      actionHidden = false
    }

    // check if user is admin
    return {
      createHidden: createHidden,
      createEnabled: !createHidden,
      actionHidden: actionHidden,
      actionEnabled: !actionHidden,
    }
  })

  this.on ('updateStock', async (req) => {
    console.log('updateStock called', req.data)
    const newStock = req.data.stock
    const keys = req.params[0]
    await UPDATE (Books, keys ).with({ stock: newStock })
    return await SELECT.one.from(Books).where(keys)
  })

  this.on ('autoFillStock', async (req) => {
    console.log('autoFillStock called')
    const lowStockBooks = await SELECT.from(Books).where({ stock: { '<': 100 } })
    // update stock to 100
    Promise.all(lowStockBooks.map(async (book) => {
      const keys = { ID: book.ID }
      await UPDATE (Books, keys ).with({ stock: 100 })
    }))
  })

  return super.init()
}}
