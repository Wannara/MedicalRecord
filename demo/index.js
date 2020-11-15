const express = require('express')
const app = express()
const port = 3000
 
const mysql = require('mysql');
 
var connection = mysql.createConnection({
    host : 'localhost',
    user : 'root',
    password : '',
    database : 'clinicmangement',
    dateStrings: true
});
 
connection.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
});

///////////////////////////////////////////////////////////////////////

app.get('/medicals',(req,res) => {
    let medical_record_id = req.query.MRno
    let medical_record = {}
    
    let med_sql = `SELECT * FROM medical_record`
    let med_drug_sql = `SELECT * FROM medical_record_drug` 

    if(medical_record_id){
        med_sql += ' WHERE MRno = ' + medical_record_id
        connection.query(med_sql,(err,result) => {
            medical_record = result[0]

            console.log(1,medical_record)
            let med_where = med_drug_sql + ` WHERE MRno = '${medical_record_id}'`
            
            console.log(2,med_where)
            connection.query(med_where,(err,result) => {     
                
            console.log(3,result)
                medical_record.drugs = result
                
            console.log(4,medical_record)
                res.send(medical_record);
            })
        })
        
        
        return
    }

    let response = []
    connection.query(med_sql,(err,med_result) => {
        med_result.forEach(mr => {
            let med_drug_sql_where  = `SELECT * FROM medical_record_drug WHERE MRno = ${mr.MRno}`
            
            connection.query(med_drug_sql_where,(err,drug_result) => {
                mr.drugs = drug_result
                response.push(mr)

                if (response.length === med_result.length) {
                    res.send(response);
                }
                
            })
        });
    })
    

});

//////////////////////////////////////////////////////////////////////////////////////////

app.post('/medicals/create', (req, res) => {
    let queryData = req.query;
    
    let mr ={
        MRno: queryData.MRno,
        doctorID: queryData.doctorID,
        HN: queryData.HN,
        SBP_DBP: queryData.SBP_DBP,
        weight_height: queryData.weight+'/'+queryData.height,
        earlySymptoms: queryData.earlySymptoms,
        diagnostic: queryData.diagnostic,
        Date: queryData.Date,
        PriceMed: queryData.PriceMed,
        drugs: queryData.drugs
    }
    let isvalid = createValidation(mr, res)
    if(!isvalid) return
    
    let med_insert =   `INSERT INTO \`medical_record\` (\`MRno\`, \`doctorID\`, \`HN\`, \`SBP/DBP\`, \`weight/height\`, \`earlySymptoms\`, \`diagnostic\`, \`Date\`, \`PriceMed\`) VALUES ( '${mr.MRno}', '${mr.doctorID}', '${mr.HN}', '${mr.SBP_DBP}', '${mr.weight_height}', '${mr.earlySymptoms}', '${mr.diagnostic}', '${mr.Date}', '${mr.PriceMed}')`
    console.log('sql insert', med_insert)
    connection.query(med_insert, (err, result) => {
        console.log('resss', result.insertId)
        let drugs = JSON.parse(mr.drugs);
        // console.log('sql', mr.drugs)
        // console.log('json', drugs)
        drugs.forEach(drug =>{
            let drugs_insert = `INSERT INTO \`medical_record_drug\` VALUES ('${result.insertId}', '${drug.drugId}', '${drug.amount}')`
        console.log(drugs_insert)
            connection.query(drugs_insert)
        })
        
        res.send('complete insert');
    })
    
});

function createValidation(mr, res) {
    let isValid = true;
    if(mr.doctorID.length !== 6){
        res.send('error DoctorID');
        isValid = false;
    }
    if(mr.HN.length !== 9){
        res.send('error HN');
        isValid = false;
    }
    if(!mr.Date){ 
        res.send('error Date')
        isValid = false;
    }

    return isValid;
}

//////////////////////////////////////////////////////////////////////////////////////////

app.put('/medicals/update', (req,res) => {
    let medical_record_id = req.query.MRno
    let mr = req.query
    console.log(mr)
    let med_sql = `SELECT * FROM medical_record WHERE MRno = ${medical_record_id}`
    let med_sql_update = `UPDATE \`medical_record\` SET \`doctorID\`= '${mr.doctorID}' ,\`HN\`= '${mr.HN}',\`SBP/DBP\`='${mr.SBP_DBP}',\`weight/height\`='${mr.weight+'/'+mr.height}',\`earlySymptoms\`= '${mr.earlySymptoms}',\`diagnostic\`='${mr.diagnostic}',\`Date\`='${mr.Date}',\`PriceMed\`='${mr.PriceMed}' WHERE MRno = ${medical_record_id}`

    if(!medical_record_id){
        res.send('MRno missing')
        return
    }

    connection.query(med_sql, (error,med) => {
        // console.log("response",mr)
        let medical_record = med[0]
        // console.log('res[0]',medical_record)
    
        if(!medical_record){
            res.send('MRno not found')
            return
        }
        // console.log('1',med_sql_update)
        connection.query(med_sql_update , (err, result) => {
            // console.log('error', err)
            if(err){
                res.send(err)
                return
            }
            let del_drug = `DELETE FROM medical_record_drug WHERE MRno = ${medical_record_id}`
            connection.query(del_drug)
            console.log("drug",mr.drugs)
            let drugs = JSON.parse(mr.drugs);
            drugs.forEach(drug =>{
                let drugs_insert = `INSERT INTO \`medical_record_drug\` VALUES ('${mr.MRno}', '${drug.drugId}', '${drug.amount}')`
                console.log(drugs_insert)
                connection.query(drugs_insert)
            })

            res.send('complete update')
        })
    })

    console.log("Update")
});

/////////////////////////////////////////////////////////////

app.delete('/medicals/delete',(req,response) =>{
    let medical_record_id = req.query.MRno

    let delete_sql = `DELETE FROM medical_record WHERE MRno = ${medical_record_id}`
    console.log(delete_sql)    

    connection.query(delete_sql,(err,result) =>{
        console.log('error',err)
        console.log(result)
        // response.send('complete delete')
    })
    response.send('complete delete')
});
///////////////////////////////////////////////////////////
app.get('/medicals/receipt',(req,res) =>{
    let medical_record_id = req.query.MRno

    // console.log('mr',medical_record_id)
    let receipt_detail_sql = `SELECT m.MRno, m.Date,m.HN,p.fname,p.lname,p.Address,m.PriceMed, mrd.drugID, d.drugName, d.Price, mrd.no_of_drug AS DrugAmount, mrd.no_of_drug*d.price as 'Total'
    FROM medical_record m
    INNER JOIN medical_record_drug mrd on m.mrno = mrd.MRno
    INNER JOIN patient p ON p.hn = m.hn
    INNER JOIN drug d ON d.drugID = mrd.drugID
    WHERE m.MRno = ${medical_record_id}`

    let medical_record = {drugs: []}

    connection.query(receipt_detail_sql,(err,result) =>{
        // console.log(result)

        result.forEach(medical_record_result =>{
            medical_record.MRno = medical_record_result.MRno
            medical_record.Date = medical_record_result.Date
            medical_record.HN = medical_record_result.HN
            medical_record.Fname = medical_record_result.fname
            medical_record.Lname = medical_record_result.lname
            medical_record.Adress = medical_record_result.Address
            medical_record.PriceMed = medical_record_result.PriceMed

            let drug = {}
            drug.drugID = medical_record_result.drugID
            drug.drugName = medical_record_result.drugName
            drug.Price = medical_record_result.Price
            drug.DrugAmount = medical_record_result.DrugAmount
            drug.Total = medical_record_result.Price * medical_record_result.DrugAmount


            medical_record.drugs.push(drug)

            // console.log('lllll'. medical_record)
        })
        medical_record.drug_Price = medical_record.drugs.reduce((prev,next)=>{
            prev += next.Total
            console.log('next',next)
            return prev
        },0)

        medical_record.TotalPrice = medical_record.PriceMed + medical_record.drug_Price

        console.log('mr',medical_record)

        res.send(medical_record)
    })
  
})

///////////////////////////////////////////////////////////


app.get('/', (req, res) => res.send('Hello World!'))
 
app.listen(port, () => console.log(`Example app listening on port ${port}!`))