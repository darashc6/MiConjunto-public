import express from "express";
import { getPublicCompanies } from "../controllers/publicCompanyController.js";

const router = express.Router();

router.get('/', getPublicCompanies);

export default router;