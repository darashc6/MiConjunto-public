import express from "express";
import {
  getMessages,
  addMessage,
  updateMessage,
} from "../controllers/messageController.js";

const router = express.Router();

router.get("/", getMessages);
router.post("/new", addMessage);
router.patch("/:messageId/update", updateMessage);

export default router;
