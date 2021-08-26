class IsFormQA {
  final String question;
  final String answer;
  final int value;

  IsFormQA(this.question, this.answer, this.value);

  IsFormQA.fromMap(Map<String, dynamic> map) :
    question = map['question'] as String,
    answer = map['answer'] as String,
    value = 0;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "question": question,
      "answer": answer,
      "value": value
    };
  }
}