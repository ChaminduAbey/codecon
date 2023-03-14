"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.attachUser = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const prismaService_1 = __importDefault(require("../services/prismaService"));
const attachUser = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = req.headers.authorization.split(" ")[1];
        const decodedToken = jsonwebtoken_1.default.verify(token, "SECRET");
        const userId = decodedToken.id;
        const prismaService = prismaService_1.default.getInstance();
        const user = yield prismaService.client.user.findUnique({
            where: {
                id: userId,
            },
        });
        if (!user) {
            throw new Error("User not found!");
        }
        req.user = user;
        next();
    }
    catch (_a) {
        res.status(401).json({
            error: "Invalid request!",
        });
    }
});
exports.attachUser = attachUser;
