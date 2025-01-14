
import db from '../Config/config.js';// Assuming a database connection module

// Create User API
const registerUser =  async (req, res) => {
    const { name, email, phone_number, designation,approval_stage, role } = req.body;

    // Validate required fields
    if (!name || !email || !role) {
        return res.status(400).json({
            message: "Name, email, and role are required."
        });
    }

    try {
        // Insert into the Users table
        const [result] = await db.execute(
            `INSERT INTO users (name, email, phone_number, designation,approval_stage, role) 
             VALUES (?, ?, ?, ?, ?,?)`,
            [name, email, phone_number || null, designation || null,approval_stage || null, role]
        );

        res.status(201).json({
            message: "User created successfully.",
            user_id: result.insertId
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            message: "Failed to create user.",
            error: error.message
        });
    }
}

export default {registerUser}
