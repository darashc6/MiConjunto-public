import express from "express";
import { readData } from "../controllers/qrReaderController.js";


const router = express.Router();

router.post('/read', readData);

export default router;
