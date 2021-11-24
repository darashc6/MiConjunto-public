import express from "express";
import { getRateParking } from "../controllers/rateParkingController.js"

const router = express.Router();

router.get("/", getRateParking);

export default router;