const cds = require('@sap/cds')

class CatalogService extends cds.ApplicationService {
    async init() {
        const { Books, Authors } = this.entities

        this.before('READ', Books, req => {
            console.log(req.path)
        })

        this.after('READ', Books, each => {
            if (each.stock < 20) each.title += ` (only a few left)`
        })

        this.before('CREATE', Authors, req => {
            req.data.nationality === req.user.attr.country || req.reject(403)
        })

        this.on('totalStock', async()=>
        {
            const query = SELECT`SUM(stock) as stock`.from(Books)
            return await cds.run(query)
        })

        this.on('submitOrder', async req => {
            const { book, quantity } = req.data

            if(quantity < 1)
                return req.reject(400, 'quantity cannot be less than 1')
        

            const result = await SELECT.one`stock`.from(Books).where({ ID: book })
            if (!result)
                return req.error(404, `Book #${book} doesn't exist`)
           
            let { stock } = result
            if (quantity > stock)
                return req.reject(409, `${quantity} exceeds the stock for book #${book}`)
    
            let newStock = stock - quantity
            await UPDATE(Books, book).with({ stock: newStock })
    
            return { newStock }            
        })
        await super.init()
    } 
}

module.exports = CatalogService