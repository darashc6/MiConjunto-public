import express from "express";
import { loginResidentialBlock } from "../controllers/residentialBlockController.js";

const router = express.Router();

router.post("/login", loginResidentialBlock);

export default router;
