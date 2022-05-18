
 ### Use Case D
 
  - Use_Case_D_Using_BERT_v1.ipynb:
      - This is a demonstration code showing the logic of the databot. The notebook is in Google Colab and requires a CUDA-enabled GPU.
      - It can be used in bot conversations for the identification of either datasets or SE Glossary articles. See instructions at the top on how to set this option.
      - The component for the identification of similar datasets or SE Glossary articles is based on the same S-BERT model used in Use Case C. See instructions on how to select the bi-encoder model.
      - The most time-consuming part is fine-tuning. This can be skipped if already run once. 
- Use_Case_D_DeepPavlov_v1.ipynb: 
      - This is the same code but implemented with the DeepPavlov framework and also with some changes and improvements.
      - Instructions are included at the top of the notebook.  
