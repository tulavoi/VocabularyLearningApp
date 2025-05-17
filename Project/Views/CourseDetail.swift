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
    @State private var flashcardIndex: Int = 0
    
    var body: some View {
        let flashcards = courseModel.selectedCourse?.flashcards ?? []
        let currentFlashcard: Flashcard? = flashcardIndex < flashcards.count ? flashcards[flashcardIndex] : nil
        
        VStack {
            header(totalFlashcard: flashcards.count)
            
            Divider()
            
            flashcardContent(flashcard: currentFlashcard)

            Spacer()
            
            buttonControls(flashcards: flashcards)
        }
        .background(Color("AddCourseBackground").ignoresSafeArea())
        .alert(isPresented: $showConfirmDelete) {
            Alert(
                title: Text("Xác nhận xoá"),
                message: Text("Bạn có chắc muốn xoá học phần này không?"),
                primaryButton: .destructive(Text("Xoá")) {
                    // Loi rang buoc voi flashcard khong xoa duoc
                    if courseModel.deleteCourse(context: viewContext, course: courseModel.selectedCourse!) {
                        dismiss()
                    }
                },
                secondaryButton: .cancel(Text("Huỷ"))
            )
        }
    }
    
    // MARK: Header
    @ViewBuilder
    private func header(totalFlashcard: Int) -> some View{
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .foregroundStyle(Color("SmallTitleColor"))
            }

            Spacer()

            Text("\(flashcardIndex + 1) / \(totalFlashcard)")
                .font(.title3.bold())
                .foregroundColor(Color("SecondaryText"))

            Spacer()
            
            Button(action: {
                showConfirmDelete = true
            }, label: {
                Image(systemName: "trash.fill")
                    .font(.title2.bold())
                    .foregroundStyle(Color("BtnTrashColor"))
            })
        }
        .padding()
    }
    
    // MARK: Flashcard Content
    @ViewBuilder
    private func flashcardContent(flashcard: Flashcard?) -> some View{
        ZStack {
            myFlashcard(text: flashcard?.term ?? "Front", isTrue: 90, isFalse: 0, isFlipped: isFlipped)
                .animation(isFlipped ? .linear : .linear.delay(0.30),
                           value: isFlipped)
            
            myFlashcard(text: flashcard?.definition ??  "Back", isTrue: 0, isFalse: -90, isFlipped: isFlipped)
                .animation(isFlipped ? .linear.delay(0.30) : .linear,
                           value: isFlipped)
        }
        .onTapGesture {
            withAnimation(.easeIn){
                isFlipped.toggle()
            }
        }
    }
    
    // MARK: Button Controls
    @ViewBuilder
    private func buttonControls(flashcards: [Flashcard]) -> some View {
        HStack(spacing: 20) {
            Button(action: {
                if flashcardIndex > 0 {
                    withAnimation {
                        flashcardIndex -= 1
                        isFlipped = false
                    }
                }
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 50)
                    .background(flashcardIndex == 0 ? Color.gray.opacity(0.5) : Color("SecondaryColor"))
                    .clipShape(Capsule())
            }
            .disabled(flashcardIndex == 0)

           Spacer()
           
            Button(action: {
                if flashcardIndex < flashcards.count - 1 {
                    withAnimation {
                        flashcardIndex += 1
                        isFlipped = false
                    }
                }
            }) {
                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 50)
                    .background(flashcardIndex == flashcards.count - 1 ? Color.gray.opacity(0.5) : Color("SecondaryColor"))
                    .clipShape(Capsule())
            }
            .disabled(flashcardIndex == flashcards.count - 1)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 10)
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
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            
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
                    .padding(.bottom, 100)

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
