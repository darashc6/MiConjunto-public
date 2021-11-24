import express from "express";
import { getReceipts, getResidentsWithPendingReceipts, addReceipt, updateReceipt } from "../controllers/receiptController.js";

const router = express.Router();

router.get("/", getReceipts);
router.get("/pending/residents", getResidentsWithPendingReceipts);
router.post("/new", addReceipt);
router.patch("/:receiptId/update", updateReceipt);

export default router;
