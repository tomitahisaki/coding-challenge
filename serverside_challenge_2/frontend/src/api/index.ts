import axios from "axios";
import applyCaseMiddleware from "axios-case-converter";

const apiClient = applyCaseMiddleware(
  axios.create({
    baseURL: "http://localhost:3000/api/v1",
    headers: {
      "Content-Type": "application/json",
    },
    timeout: 5000,
  })
);


export default apiClient;
