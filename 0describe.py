"""Generates descriptions for Verilog files using the Groq API.


"""


from groq import Groq
import os

SYSTEMS_PROMPT = """
As an expert in computer architecture, you are tasked with describing verilog code components for a single cycle MIPS processor.
You are to provide detailed explanations for each of the provided files.
You are to be a valuable resource to students who are learning about fairly advanced computer architecture and the MIPS processor.
"""


def get_prompt(file_title: str, file_content: str, file_titles: str, file_contents: str):
    return f""" 
Explain the following verilog code components for a single cycle MIPS processor
within the context of the provided code snippets found below. 
YOU MUST USE THE PROVIDED CODE SNIPPETS TO DESCRIBE THE COMPONENTS.

YOUR GIVEN CODE TO DESCRIBE/EXPLAIN:
```verilog title="{file_title}"
{file_content}
```
THE CONTEXT OF THE ABOVE FILE WITHIN THE PROCESSOR CODE:
{f"```verilog title={file_title}\n{file_content}```\n".join([f"```verilog title={file_title}\n{
        file_content}```\n" for file_title, file_content in zip(file_titles, file_contents)])}
    """


def generate(prompt: str):
    client = Groq(
        api_key='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',
    )

    chat_completion = client.chat.completions.create(
        #
        # Required parameters
        #
        messages=[
            # Set an optional system message. This sets the behavior of the
            # assistant and can be used to provide specific instructions for
            # how it should behave throughout the conversation.
            {
                "role": "system",
                "content": "you are a helpful assistant."
            },
            # Set a user message for the assistant to respond to.
            {
                "role": "user",
                "content": "Explain the importance of fast language models",
            }
        ],
        # The language model which will generate the completion.
        model="llama3-70b-8192",
        max_tokens=2048,
        stream=False,
    )
    return str(chat_completion.choices[0].message.content)


def process_verilog_files(directory: str):
    """
    Processes each Verilog file in the specified directory, writing the descriptions to separate text files.
    """
    file_titles = []
    file_contents = []
    for filename in os.listdir(directory):
        if filename.endswith(".v") or filename.endswith(".verilog"):
            file_path = os.path.join(directory, filename)
            with open(file_path, 'r') as file:
                file_content = file.read()
                file_titles.append(filename)
                file_contents.append(file_content)
    for i in range(0, len(file_titles), 2):
        file_titles_copy = file_titles.copy()
        file_contents_copy = file_contents.copy()
        prompt = get_prompt(
            file_titles[i], file_contents[i], file_titles_copy.remove(file_titles[i]), file_contents_copy.remove(file_contents[i]))
        response = generate(prompt)
        with open(f"{file_titles[i].split('.')[0]}_description.txt", 'w') as file:
            _ = file.write(response)


# Replace '.' with the directory you want to search for Verilog files
process_verilog_files('.')
