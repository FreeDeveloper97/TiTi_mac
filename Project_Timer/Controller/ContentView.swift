//
//  ContentView.swift
//  chartEx
//
//  Created by 신효근 on 2021/01/12.
//
import SwiftUI

struct ContentView: View {
    //그래프 색상 그라데이션 설정
    var colors = [Color.blue, Color.purple]
    var colors2 = [Color.red, Color.purple]
    //화면
    var body : some View {
        //세로 스크롤 설정
        ScrollView(.vertical, showsIndicators: false) {
            /* 전체 큰 틀 */
            VStack {
                Spacer(minLength: 10)
                /* 차트화면 타이틀 */
                Text("Study Time".localized())
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
                
                /* ----차트화면---- */
                VStack {
                    //평균시간 텍스트
                    Text("Average : ".localized() + getHrs(value: getAverageTime(value: getStudyTimes())))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .font(.system(size:17))
                    //그래프 틀
                    HStack(spacing:45) { //좌우로 15만큼 여백
                        ForEach(DailyDatas) {work in
                            //세로 스택
                            VStack{
                                //시간 + 그래프 막대
                                VStack{
                                    //아래로 붙이기
                                    Spacer(minLength: 0)
                                    //시간 설정
                                    Text(getHrs(value: work.studyTime))
                                        .foregroundColor(Color.white)
                                        .font(.system(size:14))
                                        .padding(.bottom,5)
                                    //그래프 막대
                                    RoundedShape()
                                        .fill(LinearGradient(gradient: .init(colors: colors), startPoint: .top, endPoint: .bottom))
                                        //그래프 막대 높이설정
                                        .frame(height:getHeight(value: work.studyTime))
                                }
                                .frame(height:250)
                                //날짜 설정
                                Text(work.day)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding()
                /* ----차트끝---- */
                Spacer(minLength: 20)
                
                /* 차트화면 타이틀 */
                Text("Rest Time".localized())
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
                
                /* ----차트화면---- */
                VStack {
                    //평균시간 텍스트
                    Text("Average : ".localized() + getHrs(value: getAverageTime(value: getBreakTimes())))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .font(.system(size:17))
                    //그래프 틀
                    HStack(spacing:45) { //좌우로 15만큼 여백
                        ForEach(DailyDatas) {work in
                            //세로 스택
                            VStack{
                                //시간 + 그래프 막대
                                VStack{
                                    //아래로 붙이기
                                    Spacer(minLength: 0)
                                    //시간 설정
                                    Text(getHrs(value: work.breakTime))
                                        .foregroundColor(Color.white)
                                        .font(.system(size:14))
                                        .padding(.bottom,5)
                                    //그래프 막대
                                    RoundedShape()
                                        .fill(LinearGradient(gradient: .init(colors: colors2), startPoint: .top, endPoint: .bottom))
                                        //그래프 막대 높이설정
                                        .frame(height:getHeight(value: work.breakTime))
                                }
                                .frame(height:250)
                                //날짜 설정
                                Text(work.day)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding()
                /* ----차트끝---- */
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }

    
    
    func getHeight(value : Int) -> CGFloat {
        let max = getMaxInTotalTime(value: DailyDatas)
        return (CGFloat(value) / CGFloat(max)) * 200
    }
    
    func getMaxInTotalTime (value : [daily]) -> Int {
        let sMax: Int = getStudyTimes().max()!
        let bMax: Int = getBreakTimes().max()!
        if sMax > bMax {
            return sMax
        } else {
            return bMax
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RoundedShape : Shape {
    func path(in rect : CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}
// Dummy Data

struct daily : Identifiable {
    var id : Int
    var day : String
    var studyTime : Int
    var breakTime : Int
}

var DailyDatas: [daily] = []


extension ContentView {
    
    func getHrs(value : Int) -> String {
        var returnString = "";
        var num = value;
        if(num < 0) {
            num = -num;
            returnString += "+";
        }
        let H = num/3600
        let M = num/60 - H*60
        
        let stringM = M<10 ? "0"+String(M) : String(M)
        
        returnString += String(H) + ":" + stringM
        return returnString
    }
    
    func translate(input: String) -> String {
        if(input == "NO DATA") {
            return "-/-"
        } else {
            print(input)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            let exported = dateFormatter.date(from: input)!
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "M/d"
            return newDateFormatter.string(from: exported)
        }
    }
    
    func translate2(input: String) -> Int {
        if(input == "NO DATA") {
            return 0
        } else {
            var sum: Int = 0
            print(input)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let exported = dateFormatter.date(from: input)!
            
            sum += Calendar.current.component(.hour, from: exported)*3600
            sum += Calendar.current.component(.minute, from: exported)*60
            sum += Calendar.current.component(.second, from: exported)
            return sum
        }
    }
    
    func appendDailyDatas(){
        for i in (1...7).reversed() {
            let id = 8-i
            let day = translate(input: UserDefaults.standard.value(forKey: "day\(i)") as? String ?? "NO DATA")
            let studyTime = translate2(input: UserDefaults.standard.value(forKey: "time\(i)") as? String ?? "NO DATA")
            let breakTime = translate2(input: UserDefaults.standard.value(forKey: "break\(i)") as? String ?? "NO DATA")
            DailyDatas.append(daily(id: id, day: day, studyTime: studyTime, breakTime: breakTime))
        }
    }
    
    func getAverageTime(value: [Int]) -> Int {
        var sum: Int = 0
        var zeroCount: Int = 0
        for i in value {
            if i == 0 {
                zeroCount += 1
            } else {
                sum += i
            }
        }
        let result: Int = value.count - zeroCount
        if result == 0 {
            return 0
        } else {
            return sum/(value.count - zeroCount)
        }
    }
    
    func getStudyTimes() -> [Int] {
        let studyArray = DailyDatas.map { (value : daily) -> Int in value.studyTime}
        return studyArray
    }
    
    func getBreakTimes() -> [Int] {
        let breakArray = DailyDatas.map { (value : daily) -> Int in value.breakTime}
        return breakArray
    }
    
    func reset() {
        DailyDatas = []
    }
    
    func appendDumyDatas(){
        DailyDatas.append(daily(id: 1, day: "2/24",
                                studyTime: translate2(input: "2:35:20"),
                                breakTime: translate2(input: "0:35:20")))
        DailyDatas.append(daily(id: 2, day: "2/23",
                                studyTime: translate2(input: "4:03:41"),
                                breakTime: translate2(input: "2:01:00")))
        DailyDatas.append(daily(id: 3, day: "2/22",
                                studyTime: translate2(input: "6:08:14"),
                                breakTime: translate2(input: "2:32:56")))
        DailyDatas.append(daily(id: 4, day: "2/21",
                                studyTime: translate2(input: "4:03:39"),
                                breakTime: translate2(input: "1:05:00")))
        DailyDatas.append(daily(id: 5, day: "2/20",
                                studyTime: translate2(input: "5:44:07"),
                                breakTime: translate2(input: "1:40:08")))
        DailyDatas.append(daily(id: 6, day: "2/19",
                                studyTime: translate2(input: "4:58:23"),
                                breakTime: translate2(input: "2:02:15")))
        DailyDatas.append(daily(id: 7, day: "2/18",
                                studyTime: translate2(input: "3:37:20"),
                                breakTime: translate2(input: "0:37:50")))
    }
}
