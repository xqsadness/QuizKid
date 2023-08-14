//
//  QuizDefault.swift
//  DefaultProject
//
//  Created by daktech on 11/08/2023.
//

import Foundation

class QUIZDEFAULT{
    static var SHARED = QUIZDEFAULT()
    
    var listQuestionsMath: [QUIZMATH] = [
        QUIZMATH(answer: "8", question: "What is 5 plus 3?", a: "7", b: "8", c: "6", d: "5"),
        QUIZMATH(answer: "5", question: "How many fingers are there on each of your hands?", a: "4", b: "5", c: "6", d: "7"),
        QUIZMATH(answer: "3", question: "If you have 4 apples and you give one to your friend, how many apples do you have left?", a: "1", b: "2", c: "3", d: "4"),
        QUIZMATH(answer: "3", question: "How many faces does a cube have?", a: "1", b: "2", c: "3", d: "6"),
        QUIZMATH(answer: "0", question: "What is 8 times 0?", a: "1", b: "3", c: "5", d: "0"),
        QUIZMATH(answer: "10", question: "If you have 10 fingers, how many fingers do you need to count to 20?", a: "10", b: "5", c: "3", d: "4"),
        QUIZMATH(answer: "4", question: "How many legs does a dog have?", a: "2", b: "3", c: "4", d: "5"),
        QUIZMATH(answer: "14", question: "What is 7 times 2?", a: "9", b: "12", c: "14", d: "21"),
        QUIZMATH(answer: "11", question: "What is 4 plus 7?", a: "54", b: "4", c: "11", d: "14"),
        QUIZMATH(answer: "Cat", question: "If a cat is in front of a chicken coop, the chicken coop is in front of the house, and the house is in front of a pond, then what is in front of a window?", a: "Chicken", b: "Cat", c: "Fish", d: "Dog"),
        QUIZMATH(answer: "9", question: "There is a bridge with 5 ducks on it. Under the bridge, there are 4 ducks. How many ducks are there in total?", a: "10", b: "8", c: "9", d: "11"),
        QUIZMATH(answer: "Go up", question: "You have 3 matchsticks. If you want to form 3 triangles by moving only one matchstick, where do you need to move it?", a: "Go up", b: "Go through the middle", c: "Go underneath", d: "Cannot be done"),
        QUIZMATH(answer: "Sunday", question: "If today is Saturday, what day is tomorrow?", a: "Saturday", b: "Sunday", c: "Monday", d: "Friday"),
        QUIZMATH(answer: "At the end of the road", question: "If you walk 10 steps along a road, where are you?", a: "At the beginning of the road", b: "In the middle of the road", c: "At the end of the road", d: "Cannot be determined"),
        QUIZMATH(answer: "4 times", question: "You have 2 red balls, 3 blue balls, and 1 yellow ball. If you randomly draw a ball from the bag, how many times do you need to draw to ensure you have at least one blue ball?", a: "2 times", b: "3 times", c: "4 times", d: "6 times"),
    ]
    
    var listQuestionsColor: [QUIZCOLOR] = [
        QUIZCOLOR(answer: "cam", question: "Qủa cam này có màu gì?", a: "Đỏ", b: "Cam", c: "Vàng", d: "Xanh", img: "cam"),
        QUIZCOLOR(answer: "Đỏ", question: "Quả cherry này có màu gì?", a: "Đỏ", b: "Xanh lá", c: "Vàng", d: "Tím", img: "cherry"),
        QUIZCOLOR(answer: "Trắng", question: "Chú chó này có màu gì?", a: "Đen", b: "Nâu", c: "Đỏ", d: "Trắng", img: "conchotrang"),
        QUIZCOLOR(answer: "Vàng", question: "Đây là màu gì?", a: "Vàng", b: "Tím", c: "Xanh dương", d: "Cam", img: "conga"),
        QUIZCOLOR(answer: "Đỏ", question: "Đây là màu gì?", a: "Lục", b: "Cam", c: "Xanh", d: "Đỏ", img: "images (1)"),
        QUIZCOLOR(answer: "Xanh dương", question: "Cô gái này đang mặc chiếc áo màu gì?", a: "Xanh dương", b: "Xanh lá cây", c: "Đen", d: "Trắng", img: "IMG_3959-scaled"),
        QUIZCOLOR(answer: "Nâu", question: "Con thỏ này có màu gì?", a: "Đen", b: "Đỏ", c: "Xám", d: "Nâu", img: "thonau"),
        QUIZCOLOR(answer: "Đỏ", question: "Đây là màu gì?", a: "Xanh", b: "Cam", c: "Đen", d: "Đỏ", img: "xedo"),
        QUIZCOLOR(answer: "Vàng", question: "Đây là màu gì?", a: "Tím", b: "Cam", c: "Xanh", d: "Vàng", img: "hinh-anh-qua-chuoi-tieu"),
        QUIZCOLOR(answer: "Đỏ", question: "Ruột của quả dưa hấu này màu gì?", a: "Vàng", b: "Xanh", c: "Đen", d: "Đỏ", img: "duahau"),
    ]
    
    var listQuestionsListen: [QUIZLISTEN] = [
        QUIZLISTEN(answer: "Shoes", question: "Shoes", a: "Shoes", b: "Gloves", c: "Coat", d: "Hat", img: ""),
        QUIZLISTEN(answer: "Mining", question: "Mining", a: "Sheep farming", b: "Gardening", c: "Baking", d: "Mining", img: ""),
        QUIZLISTEN(answer: "Planting", question: "Planting", a: "Baking", b: "Cooking rice", c: "Planting", d: "Raising chickens", img: ""),
        QUIZLISTEN(answer: "Elephant", question: "Elephant", a: "Dog", b: "Pig", c: "Elephant", d: "Cat", img: ""),
        QUIZLISTEN(answer: "Rose", question: "Rose", a: "Wild grass flower", b: "Sunflower", c: "Chrysanthemum", d: "Rose", img: ""),
        QUIZLISTEN(answer: "Mouth", question: "Mouth", a: "Nose", b: "Eye", c: "Ear", d: "Mouth", img: ""),
        QUIZLISTEN(answer: "Sun", question: "Sun", a: "Moon", b: "Sun", c: "Mercury", d: "Venus", img: ""),
        QUIZLISTEN(answer: "Planet", question: "Planet", a: "Onion", b: "Leafy greens", c: "Planet", d: "Action", img: ""),
        QUIZLISTEN(answer: "Computer", question: "Computer", a: "Desktop computer", b: "Airplane", c: "Projector", d: "Computer", img: ""),
        QUIZLISTEN(answer: "Baby", question: "Baby", a: "Youngest", b: "Baby", c: "Well-behaved", d: "Grown-up", img: ""),
    ]


    var listQuestionsSurrounding: [QUIZSURROUNDING] = [
        QUIZSURROUNDING(answer: "Quả dưa hấu", question: "Quả dưa hấu", a: "", b: "", c: "", d: "", img: "duahau"),
        QUIZSURROUNDING(answer: "Quả chuối tiêu", question: "Quả chuối tiêu", a: "", b: "", c: "", d: "", img: "hinh-anh-qua-chuoi-tieu"),
        QUIZSURROUNDING(answer: "Con thỏ nâu", question: "Con thỏ nâu", a: "", b: "", c: "", d: "", img: "thonau"),
        QUIZSURROUNDING(answer: "Áo dài", question: "Áo dài", a: "", b: "", c: "", d: "", img: "IMG_3959-scaled"),
        QUIZSURROUNDING(answer: "Quả dâu tây", question: "Quả dâu tây", a: "", b: "", c: "", d: "", img: "images (1)"),
        QUIZSURROUNDING(answer: "Con gà", question: "Con gà", a: "", b: "", c: "", d: "", img: "conga"),
        QUIZSURROUNDING(answer: "Chú chó trắng", question: "Chú chó trắng", a: "", b: "", c: "", d: "", img: "conchotrang"),
        QUIZSURROUNDING(answer: "Qủa cherry", question: "Qủa cherry", a: "", b: "", c: "", d: "", img: "cherry"),
        QUIZSURROUNDING(answer: "Quả cam", question: "Quả cam", a: "", b: "", c: "", d: "", img: "cam"),
        QUIZSURROUNDING(answer: "Xe ô tô", question: "Xe ô tô", a: "", b: "", c: "", d: "", img: "xedo"),
    ]
    
    var listQuestionsHistory: [QUIZHISTORY] = [
        QUIZHISTORY(answer: "Bà Rịa", question: "Bạn hãy cho biết năm 1933, Pháp đã sáp nhập Trường Sa vào tỉnh nào thời điểm đó?", a: "Bà Rịa", b: "Kiên Giang", c: "Gia Định", d: "Khánh Hòa", img: ""),
        QUIZHISTORY(answer: "Campuchia", question: "Việt Nam", a: "Quần đảo Hoàng Xa và Trường Xa là của nước nào?", b: "Thái Lan", c: "Lào", d: "Trung Quốc", img: ""),
        QUIZHISTORY(answer: "không can thiệp vào công việc nội bộ của bất kì nước nào.", question: "Một trong những nguyên tắc của Liên hợp quốc là", a: "tôn trọng toàn vẹn lãnh thổ và độc lập chính trị của tất cả các nước.", b: "tôn trọng quyền làm chủ của các nước.", c: "không can thiệp vào công việc nội bộ của bất kì nước nào.", d: "giữ gìn hòa bình, an ninh cho mỗi nước.", img: ""),
        QUIZHISTORY(answer: "Tiêu diệt tận gốc chủ nghĩa phát xít Đức và quân phiệt Nhật.", question: "Để kết thúc nhanh Chiến tranh thế giới thứ hai ở châu Âu và châu Á - Thái Bình Dương, ba cường quốc Liên Xô, Anh, Mĩ đã thống nhất mục đích gì?", a: "Sử dụng bom nguyên tử để tiêu diệt phát xít Nhật.", b: "Hồng quân Liên Xô nhanh chóng tấn công tận sào huyệt của phát xít Đức ở Béclin.", c: "Tiêu diệt tận gốc chủ nghĩa phát xít Đức và quân phiệt Nhật.", d: "Tập trung lực lượng đánh bại phát xít Nhật ở châu Á.", img: ""),
        QUIZHISTORY(answer: "chống Liên Xô và các nước xã hội chủ nghĩa.", question: "Tháng 3-1947, Tổng thống Truman của Mĩ chính thức phát động cuộc “Chiến tranh lạnh” nhằm mục đích?", a: "chống Liên Xô và các nước xã hội chủ nghĩa.", b: "giữ vững nền hòa bình, an ninh thế giới sau chiến tranh.", c: "xoa dịu tinh thần đấu tranh của công nhân ở các nước tư bản chủ nghĩa", d: "chống phong trào giải phóng dân tộc ở Mĩ Latinh.", img: ""),
        QUIZHISTORY(answer: "giữ vai trò trọng yếu hàng đầu trong việc duy trì hòa bình an ninh thế giới.", question: "Vai trò của Hội đồng Bảo an Liên hợp quốc là?", a: "giữ vai trò trọng yếu hàng đầu trong việc duy trì hòa bình an ninh thế giới.", b: "giữ vai trò bảo vệ các quyền dân tộc cơ bản của các nước.", c: "giữ vai trò bảo vệ hòa bình cho các nước.", d: "giữ vai trò ngăn chặn không cho các nước vi phạm chủ quyền lẫn nhau.", img: ""),
        QUIZHISTORY(answer: "vẫn thuộc phạm vi của các nước phương Tây.", question: "Việc phân chia khu vực chiếm đóng của các nước trong phe Đồng minh tại Hội nghị Ianta năm 1945 đối với các nước Đông Nam Á, Nam Á?", a: "thuộc phạm vi ảnh hưởng của Mĩ và Anh.", b: "do Liên Xô chiếm đóng và kiểm soát.", c: "vẫn thuộc phạm vi của các nước phương Tây.", d: "tạm thời quân đội Liên Xô và Mĩ chia nhau kiểm soát và đóng quân.", img: ""),
        QUIZHISTORY(answer: "Triệu tập Hội nghị tại Ianta (Liên Xô) từ ngày 04 đến ngày 11-02-1945.", question: "Vào giai đoạn cuối của Chiến tranh thế giới thứ hai, các nước Đồng minh đã làm gì để thay đổi tình hình thế giới?", a: "Tấn công như vũ bão vào thủ đô Béclin của Đức.", b: "Đặt yêu cầu nhanh chóng đánh bại hoàn toàn các nước phát xít.", c: "Gấp rút tổ chức lại thế giới mới sau chiến tranh.", d: "Triệu tập Hội nghị tại Ianta (Liên Xô) từ ngày 04 đến ngày 11-02-1945.", img: ""),
        QUIZHISTORY(answer: "thế giới bị chia thành hai phe tư bản chủ nghĩa và xã hội chủ nghĩa.", question: "Căn nguyên dẫn đến cuộc Chiến tranh lạnh sau Chiến tranh thế giới thứ hai là", a: "thế giới bị chia thành hai phe tư bản chủ nghĩa và xã hội chủ nghĩa.", b: "sự phân chia ảnh hưởng sau Chiến tranh thế giới thứ hai chưa thỏa mãn.", c: "sự bất đồng trong Hội nghị Ianta.", d: "Mĩ không đạt được quyền lợi trong Hội nghị Ianta.", img: ""),
        QUIZHISTORY(answer: "vai trò của Liên hợp quốc.", question: "Giải quyết các vụ tranh chấp và xung đột nhiều khu vực bằng biện pháp hoà bình, đó là một trong các nội dung của", a: "nguyên tắc Liên hợp quốc.", b: "vai trò của Liên hợp quốc.", c: "nghị quyết Hội nghị Ianta.", d: "mục đích của Liên hợp quốc.", img: ""),
    ]
}

struct QUIZMATH {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
}

struct QUIZCOLOR {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var img: String = ""
}

struct QUIZSURROUNDING {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var img: String = ""
}

struct QUIZLISTEN {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var img: String = ""
}

struct QUIZHISTORY {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var img: String = ""
}
