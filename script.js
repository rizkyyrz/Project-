const questions = [
    {
        question: 'Apa kepanjangan dari HTML?',
        choices: ['Hyperlinks and Text Markup Language', 'Hypertext Markup Language', 'Hyper Text Markup Link', 'Home Tool Markup Language'],
        answer: 1
    },
    {
        question: 'Apa fungsi dari JavaScript?',
        choices: ['Untuk mengatur tampilan halaman web', 'Untuk menghubungkan halaman web dengan database', 'Untuk membuat tampilan halaman web lebih menarik dan interaktif', 'Semua jawaban benar'],
        answer: 2
    },
    {
        question: 'Apa kepanjangan dari CSS?',
        choices: ['Computer Style Sheets', 'Cascading Style Sheets', 'Creative Style Sheets', 'Colorful Style Sheets'],
        answer: 1
    }
];

let currentQuestion = 0;
let score = 0;

function showQuestion() {
    const questionElement = document.getElementById('question');
    const choicesElement = document.getElementById('choices');

    questionElement.textContent = questions[currentQuestion].question;
    choicesElement.innerHTML = '';

    questions[currentQuestion].choices.forEach((choice, index) => {
        const button = document.createElement('button');
        button.textContent = choice;
        button.setAttribute('data-index', index);
        button.onclick = checkAnswer;
        choicesElement.appendChild(button);
    });
}

function checkAnswer(e) {
    if (e) {
        const selectedChoice = parseInt(e.target.getAttribute('data-index'));
        if (selectedChoice === questions[currentQuestion].answer) {
            score++;
        }
    }

    currentQuestion++;

    if (currentQuestion < questions.length) {
        showQuestion();
    } else {
        showResult();
    }
}

function showResult() {
    const container = document.querySelector('.container');
    container.innerHTML = `
        <h2>Hasil Quiz</h2>
        <p>Anda berhasil menjawab ${score} dari ${questions.length} pertanyaan dengan benar.</p>
    `;
}

showQuestion();
