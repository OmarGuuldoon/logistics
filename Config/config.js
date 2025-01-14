import mysql from 'mysql2/promise.js';
import dotenv from 'dotenv/config';

const db = mysql.createPool({
    host : process.env.DB_HOST,
    user : process.env.DB_USERNAME,
    password : process.env.DB_PASSWORD,
    database : process.env.DB_NAME
});


const checkDatabaseConnection = async () => {
    try {
      const [rows] = await db.query("SELECT 1");
      console.log('Database connnection succesfully');
    }
    catch {
      console.error("something went wrong " + error.stack);  
    }
}
    
  
  checkDatabaseConnection();

  
export default db;

