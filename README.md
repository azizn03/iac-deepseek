# IaC-DeepSeek  

🚀 **Infrastructure as Code (IaC) for Deploying DeepSeek on AWS**  
This project automates the deployment of a DeepSeek instance in AWS, integrated with Ollama to provide chatbot-like functionality accessible via a web browser, similar to ChatGPT.  

## 📖 Inspiration  
[Deploying DeepSeek R1 14B on Amazon EC2](https://community.aws/content/2sEuHQlpyIFSwCkzmx585JckSgN/deploying-deepseek-r1-14b-on-amazon-ec2)  

## Setup

### Export AWS credentials 
```bash
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```

## ✅ To-Do List  
- [ ] Complete IaC Implementation  
- [ ] Integrate CI/CD for accessibility
- [ ] Implement principle of least privilege
- [ ] Automate the generation of a self-signed certificate for HTTPS access
- [ ] Implement AWS SageMaker integration in the future?