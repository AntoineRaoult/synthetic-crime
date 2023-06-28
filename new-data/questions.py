# Provide the path to your RTF file
rtf_file_path = '/home/drackmo/Desktop/UKDA-8971-tab/mrdoc/dcms_csbs_combined_2016-2022_banded_cost_data_only_v3_public_ukda_data_dictionary.rtf'

with open(rtf_file_path, 'r', encoding='utf-8', errors='replace') as infile:
    content = infile.read()

questions = content.split('{\\cf4 ')
questions = list(filter(lambda x: x.startswith('Q'), questions))
questions = list(map(lambda x: x.split('\\par }')[0], questions))

question_numbers = set()
final_content = []

for question in questions:
    question_number = question.split(' ')[0]
    if question_number in question_numbers:
        continue
    question_numbers.add(question_number)
    final_content.append(question)

for question in final_content:
    print(question)