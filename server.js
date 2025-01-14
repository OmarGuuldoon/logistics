import ('dotenv/config');
import http from "http";
import app from "./index.js";
import db_connection from "./Config/config.js";


const server = http.createServer(app);
server.listen(process.env.PORT,'0.0.0.0', ()=> {''
    console.log("server started at port " + process.env.PORT)
});