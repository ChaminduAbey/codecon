import express from "express";
import userLoader from "./routes/user";
import projectLoader from "./routes/projects";
import reviewLoader from "./routes/review";

const app = express();

// add body parser
app.use(express.json());

userLoader({ app });
projectLoader({ app });
reviewLoader({ app });

app.listen(3000, () => {
  console.log("Listening on port 3000");
});
