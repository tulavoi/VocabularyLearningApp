//
//  CourseDetail.swift
//  Project
//
//  Created by  User on 12.05.2025.
//

import SwiftUI

struct CourseDetail: View {
    @EnvironmentObject private var courseModel: CourseViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showConfirmDelete: Bool = false
    @State private var isFlipped: Bool = false
    
    var body: some View {
        VStack {
            header()
            
            Divider()
            
            flashcardContent()

            Spacer()
            
            buttonControls()
        }
        .background(Color("AddCourseBackground").ignoresSafeArea())
        
// Delete Course Button
//            Button(action: {
//                showConfirmDelete = true
//            }, label: {
//                Image(systemName: "trash")
//                    .font(.title3.bold())
//                    .foregroundStyle(.red)
//            })
//        }
//        .alert(isPresented: $showConfirmDelete) {
//            Alert(
//                title: Text("Xác nhận xoá"),
//                message: Text("Bạn có chắc muốn xoá học phần này không?"),
//                primaryButton: .destructive(Text("Xoá")) {
//                    if courseModel.deleteCourse(context: viewContext, course: courseModel.selectedCourse!) {
//                        dismiss()
//                    }
//                },
//                secondaryButton: .cancel(Text("Huỷ"))
//            )
//        }
        
    }
    
    // MARK: Header
    @ViewBuilder
    private func header() -> some View{
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .foregroundStyle(Color("SmallTitleColor"))
            }

            Spacer()

            Text(courseModel.selectedCourse?.title ?? "Course detail")
                .font(.title3.bold())
                .foregroundColor(Color("SecondaryText"))

            Spacer()

            Button(action: {
                // Action for settings button
            }) {
                Image(systemName: "gearshape")
                    .font(.title2.bold())
                    .foregroundStyle(Color("SmallTitleColor"))
            }
        }
        .padding()
    }
    
    // MARK: Flashcard Content
    @ViewBuilder
    private func flashcardContent() -> some View{
        ZStack {
            myFlashcard(text: "Back", isTrue: 0, isFalse: -90, isFlipped: isFlipped)
                .animation(isFlipped ? .linear.delay(0.35) : .linear,
                           value: isFlipped)

            myFlashcard(text: "Front", isTrue: 90, isFalse: 0, isFlipped: isFlipped)
                .animation(isFlipped ? .linear : .linear.delay(0.35),
                           value: isFlipped)
        }
        .onTapGesture {
            withAnimation(.easeIn){
                isFlipped.toggle()
            }
        }
    }
    
    @ViewBuilder
    private func cardFaceContent() -> some View{
        VStack{
            // Nội dung của mặt trước và mặt sau
            if !isFlipped { // Hiển thị mặt trước khi chưa lật
                VStack {
                    HStack {
                        Button(action: {
                            // Action for sound button
                        }) {
                            Image(systemName: "speaker.wave.2")
                                .font(.title2)
                                .foregroundColor(Color("SmallTitleColor"))
                        }

                        Spacer()

                        Button(action: {
                            // Action for starred button
                        }) {
                            Image(systemName: "star")
                                .font(.title2)
                                .foregroundColor(Color("SmallTitleColor"))
                        }
                    }
                    .padding(.horizontal, 40)

                    Spacer()

                    Text("ハンカチ")
                        .font(.title)
                        .padding()
                    
                    Spacer()
                }
                .padding(.vertical, 30)
                // Đảm bảo nội dung mặt trước chỉ hiển thị khi chưa lật và không bị ảnh hưởng bởi xoay
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0),
                                  axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            } else { // Hiển thị mặt sau khi đã lật
                VStack {
                     HStack {
                         Spacer()

                         Button(action: {
                             // Action for starred button
                         }) {
                             Image(systemName: "star")
                                 .font(.title2)
                                 .foregroundColor(Color("SmallTitleColor"))
                         }
                     }
                     .padding(.horizontal, 40)

                    Spacer()

                    Text("Khăn tay")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()

                    Spacer()
                }
                 .padding(.vertical, 30)
                 // Đảm bảo nội dung mặt sau hiển thị đúng hướng sau khi lật 180 độ
                 .rotation3DEffect(
                     .degrees(isFlipped ? 180 : 0),
                     axis: (x: 0.0, y: 1.0, z: 0.0)
                 )
            }
        }
    }
    
    // MARK: Button Controls
    @ViewBuilder
    private func buttonControls() -> some View {
        HStack {
            Button(action: {
                // Action for rewind button
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(Color("SmallTitleColor"))
            }

            Spacer()

            Button(action: {
                // Action for play/forward button
            }) {
                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundColor(Color("SmallTitleColor"))
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
    }
}

struct myFlashcard: View {
    var text: String
    var isTrue: CGFloat
    var isFalse: CGFloat
    var isFlipped: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
               .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("BorderColor"), lineWidth: 3)
                )
                .foregroundStyle(.white)
                .padding(30)
            
            VStack {
                HStack {
                    Button(action: {
                        // Action for sound button
                    }) {
                        Image(systemName: "speaker.wave.2")
                            .font(.title2)
                            .foregroundColor(Color("SmallTitleColor"))
                    }

                    Spacer()

                    Button(action: {
                        // Action for star button
                    }) {
                        Image(systemName: "star")
                            .font(.title2)
                            .foregroundColor(Color("SmallTitleColor"))
                    }
                }
                .padding(40)

                Spacer()

                // Nội dung chính của flashcard
                Text(text)
                    .font(.title)

                Spacer()
            }
            .padding()
        }
        .rotation3DEffect(.degrees(isFlipped ? isTrue : isFalse),
                          axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
}

struct CourseDetail_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetail()
            .environmentObject(CourseViewModel())
    }
}
