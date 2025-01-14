import Joi from 'joi';

// Define Joi schema for validation
const addressSchema = Joi.object({
    branch_name: Joi.string().min(3).max(255).required().messages({
        'string.base': 'Branch name should be a string',
        'string.empty': 'Branch name cannot be empty',
        'string.min': 'Branch name should be at least 3 characters',
        'string.max': 'Branch name should be less than 255 characters',
        'any.required': 'Branch name is required',
    }),
    attention_to: Joi.string().min(3).max(255).optional().messages({
        'string.base': 'Attention to should be a string',
        'string.empty': 'Attention to cannot be empty',
        'string.min': 'Attention to should be at least 3 characters',
        'string.max': 'Attention to should be less than 255 characters',
    }),
    designation: Joi.string().min(3).max(255).optional().messages({
        'string.base': 'Designation should be a string',
        'string.empty': 'Designation cannot be empty',
        'string.min': 'Designation should be at least 3 characters',
        'string.max': 'Designation should be less than 255 characters',
    }),
    location_details: Joi.string().min(5).required().messages({
        'string.base': 'Location details should be a string',
        'string.empty': 'Location details cannot be empty',
        'string.min': 'Location details should be at least 5 characters',
        'any.required': 'Location details are required',
    }),
    email: Joi.string().email().optional().messages({
        'string.base': 'Email should be a string',
        'string.email': 'Email should be a valid email address',
    }),
    mobile: Joi.string().pattern(/^[0-9+]{10,15}$/).optional().messages({
        'string.base': 'Mobile number should be a string',
        'string.pattern.base': 'Mobile number should be in a valid format (e.g., +2527709169)',
    }),
});

export default   addressSchema ;
