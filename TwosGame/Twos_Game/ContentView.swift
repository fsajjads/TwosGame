//
//  ContentView.swift
//  assign2
//
//  Created by Fahim Sajjad on 9/23/21.
//

import SwiftUI

private func backgroundColor(for value : Int) -> Color{
    let numbers: Int = value
    switch numbers{
    case 0:
        return Color(red:250 / 255 , green: 200 / 255 , blue:135 / 255)
    case 2:
        return Color.yellow
    case 4:
        return Color.blue
    case 8:
        return Color.green
    case 16:
        return Color.purple
    case 32:
        return Color(red:220/255, green: 120/255 , blue:120/255)
    case 64:
        return Color.red
    case 128:
        return Color.pink
    case 256:
        return Color.orange
    default:
        return Color.gray
    }
}
private func  formatDate(value : Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss, MMM d, yyyy"
    return formatter.string(from: value)
}

struct ContentView: View {
    @StateObject var game_board = Twos()
    @State var selection = false
    @State var end_check = false
    @State var direction = "up"
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        
        
        TabView {
            ZStack{
                
                
                if verticalSizeClass == .regular {
                    
                    VStack{
                        Spacer()
                        ScoreView()
                            .padding(.bottom, 15.0)
                            
                            
                        
                        
                        GridView(direction:$direction)
                            
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onEnded({ value in
                                
                                if (abs(value.startLocation.x - value.location.x) > abs(value.startLocation.y - value.location.y)){
                                    if value.startLocation.x > value.location.x {
                                        withAnimation {
                                            game_board.collapse(dir: .left)
                                            let temp = game_board
                                            if temp.collapse(dir: .left) == true || temp.collapse(dir: .right) == true || temp.collapse(dir: .right) == true ||
                                                temp.collapse(dir: .up) == true || temp.collapse(dir:.down) == true {
                                                end_check = true
                                                game_board.scorelist.append(Score(score: game_board.score, time: Date()))
                                            }else{
                                                game_board.spawn()
                                            }
                                        }
                                    } else if value.startLocation.x < value.location.x {
                                        withAnimation {
                                            game_board.collapse(dir: .right)
                                            
                                            let temp = game_board
                                            if temp.collapse(dir: .left) == true || temp.collapse(dir: .right) == true || temp.collapse(dir: .right) == true ||
                                                temp.collapse(dir: .up) == true || temp.collapse(dir:.down) == true{
                                                end_check = true
                                                game_board.scorelist.append(Score(score: game_board.score, time: Date()))
                                            }else{
                                                game_board.spawn()
                                            }
                                        }
                                    }
                                }else{
                                    if value.startLocation.y < value.location.y {
                                        withAnimation {
                                            game_board.collapse(dir: .down)
                                            let temp = game_board
                                            if temp.collapse(dir: .left) == true || temp.collapse(dir: .right) == true || temp.collapse(dir: .right) == true ||
                                                temp.collapse(dir: .up) == true || temp.collapse(dir:.down) == true{
                                                end_check = true
                                                game_board.scorelist.append(Score(score: game_board.score, time: Date()))
                                            }else{
                                                game_board.spawn()
                                            }
                                        }
                                    } else if value.startLocation.y > value.location.y {
                                        withAnimation {
                                            game_board.collapse(dir:.up)
                                            
                                            let temp = game_board
                                            if temp.collapse(dir: .left) == true || temp.collapse(dir: .right) == true || temp.collapse(dir: .right) == true ||
                                                temp.collapse(dir: .up) == true || temp.collapse(dir:.down) == true{
                                                end_check = true
                                                game_board.scorelist.append(Score(score: game_board.score, time: Date()))
                                            }else{
                                                game_board.spawn()
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                }
                                
                            })).alert(isPresented: $end_check) {
                                Alert(
                                    title: Text("Game Ended"),
                                    message: Text("Your Score Is : \(game_board.score)"),
                                    dismissButton: Alert.Button.default(
                                          Text("Start New Game"),
                                             action: {
                                                
                                        game_board.newgame(rand: selection)
                                              }
                                            )
                                )
                            }
                            
                        
                        Upbtn(end_check: $end_check, selection: $selection)
                        HStack{
                            Leftbtn(end_check:$end_check, selection: $selection)
                                .padding(.leading, 70.0)
                            Spacer()
                            Rightbtn(end_check:$end_check, selection: $selection)
                                .padding(.trailing, 65.0)
                        }
                        Downbtn(end_check:$end_check, selection: $selection)
                        NewGame(selection:$selection)
                            .padding(.bottom, 20.0)
                        
                        GameMode(selection: $selection)
                        
                        
                        
                        Spacer()
                        Spacer()
                        
                    }
                    
                    
                    // end of landscape
                }else {
                    
                    
                    HStack{
                        
                        
                        GridView(direction:$direction)
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded(({value in
                                if value.translation.width > 0 {
                                    game_board.collapse(dir: .right)
                                    
                                    let temp = game_board
                                    if(game_board.game_ended(input: temp) == true){
                                        end_check = true
                                        game_board.scorelist.append(Score(score: game_board.score, time: Date()))
                                    }else{
                                        game_board.spawn()
                                    }
                                }else if value.translation.width < 0 {
                                    game_board.collapse(dir: .left)
                                    
                                    let temp = game_board
                                    if(game_board.game_ended(input: temp) == true){
                                        end_check = true
                                        game_board.scorelist.append(Score(score: game_board.score, time: Date()))
                                    }else{
                                        game_board.spawn()
                                    }
                                }else if value.translation.height > 0 {
                                    game_board.collapse(dir: .down)
                                    
                                    var temp = game_board
                                    if(game_board.game_ended(input: temp) == true){
                                        end_check = true
                                        game_board.scorelist.append(Score(score: game_board.score, time: Date()))
                                    }else{
                                        game_board.spawn()
                                    }
                                }else if value.translation.height < 0 {
                                    game_board.collapse(dir: .up)
                                    
                                    let temp = game_board
                                    if(game_board.game_ended(input: temp) == true){
                                        end_check = true
                                        game_board.scorelist.append(Score(score: game_board.score, time: Date()))
                                    }else{
                                        game_board.spawn()
                                    }
                                }
                            }))).alert(isPresented: $end_check) {
                                Alert(
                                    title: Text("Game Ended"),
                                    message: Text("Your Score Is : \(game_board.score)"),
                                    dismissButton: Alert.Button.default(
                                          Text("Start New Game"),
                                             action: {
                                                
                                        game_board.newgame(rand: selection)
                                              }
                                            )
                                )
                            }
                            
                        
                        VStack{
                            ScoreView()
                            Upbtn(end_check: $end_check, selection: $selection)
                            HStack{
                                Leftbtn(end_check:$end_check, selection:$selection)
                                    .padding(.leading, 70.0)
                                Spacer()
                                Rightbtn(end_check:$end_check, selection: $selection)
                                    .padding(.trailing, 65.0)
                            }
                            Downbtn(end_check:$end_check, selection: $selection)
                            NewGame(selection:$selection)
                               
                            GameMode(selection: $selection)
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    //end of landscape
                    
                }
                
                
                
                
                
            }
            
            .environmentObject(game_board)
            
            .tabItem {
                
                Label("Board", systemImage: "gamecontroller")
            }
            
            
            //**********************    Score page *******************************
            ZStack{
                
                List(0..<game_board.scorelist.count, id: \.self) { i in
                    
                    HStack{
                        
                        Text("\(game_board.sortScoreList()[i].score)" as String)
                        Spacer()
                        Text(formatDate(value: game_board.scorelist[i].time))
                    }
                }
            }
            .tabItem {
                Label("Scores", systemImage: "list.dash")
            }
            //**********************    Aboout page *******************************
            About()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        
        
        
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GridView: View {
    @EnvironmentObject var game_board : Twos
    @Binding var direction:String
    
    var body: some View {
        
        
        ZStack{
            //create a ZStack
            ZStack{
                ForEach(game_board.board.reduce([], +)){ tile in
                    if tile.val !=  0 {
                        TileView(tile: tile)
                            .offset(CGSize(width: -110, height: -115))
                            .animation(.easeInOut(duration: 1))
                    }
                    
                }
            } .animation(.easeInOut(duration:1))
            
            
            ZStack{
                ForEach(game_board.board.reduce([], +)){ tile in
                    
                    if tile.val == 0{
                        TileView(tile: tile)
                            .offset(CGSize(width: -110, height: -115))
                        
                    }
                }
            }
            
           
            
        }
        
        .frame(width: 70 * 4, height: 70 * 4)
        
    }
}









struct TileView: View {
    var tile = Tile(val: 0, row: 0, col: 0)
    
    
    init(tile: Tile) {
        self.tile = tile
        
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(backgroundColor(for: tile.val))
                .padding(.all, 3.0)
                .frame(width:70, height: 70)
            
            if tile.val != 0{
                Text(String(tile.val.description))
                    .fontWeight(.bold)
                //                                        .foregroundColor(Color.black)
                    .padding(.all, 20.0)
                    .frame(width: 80.0)
                    .cornerRadius(10)
                
            }
            
        }
        .animation(.easeInOut(duration: 1.5))
        .offset(CGSize(width:70 * tile.col , height: 70 * tile.row))
        
    }
}

struct ScoreView: View{
    @EnvironmentObject var game_board : Twos
    
    var body: some View {
        Text("Score : \(game_board.score)")
            .bold()
            .frame(width:150, height:50)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemPink), Color(.systemPurple)]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
            )
            .clipShape(Capsule())
    }
    
}

struct Upbtn : View{
    @EnvironmentObject var game_board : Twos
    @Binding var end_check: Bool
    @Binding var selection : Bool

    var body: some View {
        
        Button(action:{
            _ =  game_board.collapse(dir: .up)
            
            
            let temp = game_board
            if(game_board.game_ended(input: temp) == true){
                end_check = true
                game_board.scorelist.append(Score(score: game_board.score, time: Date()))
            }
            else{
                game_board.spawn()
            }
        }){
            Text("Up")
                .bold()
                .frame(width:100, height:50)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.systemPink), Color(.systemPurple)]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                )
                .clipShape(Capsule())
            
        }.alert(isPresented: $end_check) {
            Alert(
                title: Text("Game Ended"),
                message: Text("Your Score Is : \(game_board.score)"),
                dismissButton: Alert.Button.default(
                      Text("Start New Game"),
                         action: {
                            
                    game_board.newgame(rand: selection)
                          }
                        )
            )
        }
        
        
        
        
    }
}

struct Leftbtn : View{
    @EnvironmentObject var game_board : Twos
    @Binding var end_check: Bool
    @Binding var selection : Bool

    var body: some View {
        
        Button{
            _ = game_board.collapse(dir: .left)
            
            let temp = game_board
            if(game_board.game_ended(input: temp) == true){
                end_check = true
                game_board.scorelist.append(Score(score: game_board.score, time: Date()))
            }
            else{
                game_board.spawn()
            }
            
            
        }label: {
            Text("Left")
                .bold()
                .frame(width:100, height:50)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.systemPink), Color(.systemPurple)]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                )
                .clipShape(Capsule())
            
            
        }.alert(isPresented: $end_check) {
            Alert(
                title: Text("Game Ended"),
                message: Text("Your Score Is : \(game_board.score)"),
                dismissButton: Alert.Button.default(
                      Text("Start New Game"),
                         action: {
                            
                    game_board.newgame(rand: selection)
                          }
                        )
            )
        }
        
        
        
        
    }
}



//Right button

struct Rightbtn : View{
    @EnvironmentObject var game_board : Twos
    @Binding var end_check: Bool
    @Binding var selection : Bool

    var body: some View {
        
        Button{
            _ = game_board.collapse(dir: .right)
            
            let temp = game_board
            if(game_board.game_ended(input: temp) == true){
                end_check = true
                game_board.scorelist.append(Score(score: game_board.score, time: Date()))
            }else{
                game_board.spawn()
            }
            
        }label: {
            Text("Right")
                .bold()
                .frame(width:100, height:50)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.systemPink), Color(.systemPurple)]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                )
                .clipShape(Capsule())
            
            
        }.alert(isPresented: $end_check) {
            Alert(
                title: Text("Game Ended"),
                message: Text("Your Score Is : \(game_board.score)"),
                dismissButton: Alert.Button.default(
                      Text("Start New Game"),
                         action: {
                            
                    game_board.newgame(rand: selection)
                          }
                        )
            )
        }
        
        
        
    }
}

struct Downbtn : View{
    @EnvironmentObject var game_board : Twos
    @Binding var end_check: Bool
    @Binding var selection : Bool

    var body: some View {
        
        Button{
            _ = game_board.collapse(dir:.down)
            
            let temp = game_board
            if(game_board.game_ended(input: temp) == true){
                end_check = true
                game_board.scorelist.append(Score(score: game_board.score, time: Date()))
            }else{
                game_board.spawn()
            }
            
        }label: {
            Text("Down")
                .bold()
                .frame(width:100, height:50)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.systemPink), Color(.systemPurple)]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                )
                .clipShape(Capsule())
            
            
        }.alert(isPresented: $end_check) {
            Alert(
                title: Text("Game Ended"),
                message: Text("Your Score Is : \(game_board.score)"),
                dismissButton: Alert.Button.default(
                      Text("Start New Game"),
                         action: {
                            
                    game_board.newgame(rand: selection)
                          }
                        )
            )
        }
        
        
        
    }
}


struct NewGame : View{
    @EnvironmentObject var game_board : Twos
    @Binding var selection : Bool
    var body: some View {
        
        Button(action:{
            game_board.newgame(rand: selection)
            game_board.spawn()
            game_board.spawn()
            
        }){
            Text("New Game")
                .bold()
                .frame(width:150, height:50)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.systemPink), Color(.systemPurple)]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                )
                .clipShape(Capsule())
        }
        
        
        
        
    }
}

struct GameMode : View{
    @EnvironmentObject var game_board : Twos
    @Binding var selection : Bool
    
    var body: some View {
        
        
        Picker(
            selection: $selection,
            label: Text("Picker"),
            content: {
                Text("Random").tag(true)
                Text("Determ").tag(false)
            })
            .padding(.horizontal, 40.0)
            .pickerStyle(SegmentedPickerStyle())
        
        
        
        
    }
    
    
    
    
    
    
}




