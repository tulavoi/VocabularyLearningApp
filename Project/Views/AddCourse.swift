//
//  AddCourse.swift
//  Project
//
//  Created by  User on 05.05.2025.
//

import SwiftUI

struct AddCourse: View {
    @EnvironmentObject private var courseModel: CourseViewModel
    @Environment(\.managedObjectContext) private var context
    @Environment(\.self) private var env

    @StateObject private var languageModel: LanguageViewModel

    @State private var scrollToFlashcardIndex: Int? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FocusState private var focusedIndex: Int?
    
    init() {
        _languageModel = StateObject(wrappedValue: LanguageViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                header()
                VStack(alignment: .leading) {
                    courseTitleField()
                    ScrollViewReader { proxy in
                        ScrollView {
                            flashcardFields()
                        }
                        .onChange(of: scrollToFlashcardIndex){ index in
                            if let index = index{
                                withAnimation{
                                    proxy.scrollTo(index, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height, alignment: .top)
                .background(Color("AddCourseBackground"))
            }
            Spacer()
            addFlashcardFieldsButton()
        }
        .fullScreenCover(isPresented: $languageModel.openChooseLanguage){
            ChooseLanguage()
                .environmentObject(languageModel)
                .environmentObject(courseModel)
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text(alertMessage), dismissButton: .default(Text("OK").foregroundColor(Color("BlueColor"))))
        }
    }
    
    // MARK: Header
    @ViewBuilder
    private func header() -> some View{
        ZStack {
            Color.white
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
            
            HStack {
                Button {
                    env.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                        .foregroundStyle(Color("SmallTitleColor"))
                }
                
                Spacer()
   
                Text("Tạo học phần")
                    .font(.title2.bold())
                
                Spacer()
                
                Button {
                    if let validationError = courseModel.validateCourseCreation(){
                        alertMessage = validationError
                        showAlert = true
                    } else {
                        if courseModel.addCourse(context: env.managedObjectContext) {
                            env.dismiss()
                        }
                    }
                } label: {
                    Image(systemName: "checkmark")
                        .font(.title3.bold())
                        .foregroundStyle(Color("SmallTitleColor"))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
        .frame(height: 60)
    }
    
    // MARK: Course Title Field
    @ViewBuilder
    private func courseTitleField() -> some View{
        VStack(alignment: .leading){
            TextField("Nhập tiêu đề...", text: $courseModel.courseTitle)
                .padding(5)
                .overlay(
                    Rectangle()
                        .frame(height: 5)
                        .padding(.top, 35)
                        .foregroundColor(Color("NavyColor")),
                    alignment: .topLeading
                )
                .padding(.bottom, 15)
            Text("TIÊU ĐỀ")
                .font(.headline)
                .foregroundColor(Color("SecondaryColor"))
        }
        .padding(.vertical, 10)
        .padding()
    }
    
    // MARK: Add FlashcardFields Button
    @ViewBuilder
    private func addFlashcardFieldsButton() -> some View{
        Button(action: {
            // Sinh ra 1 FlashcardFields
            courseModel.flashcards.append(FlashcardViewModel())
            scrollToFlashcardIndex = courseModel.flashcards.count - 1
        }) {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color("BlueColor"))
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .padding(.trailing)
    }
    
    // MARK: Flashcard Fields
    @ViewBuilder
    private func flashcardFields() -> some View{
        VStack(alignment: .leading, spacing: 15) {
            ForEach(courseModel.flashcards.indices, id: \.self) { index in
                SwipeContainerView(onDelete: {
                    withAnimation {
                        if courseModel.flashcards.count == 2 {
                            alertMessage = "Học phần phải có ít nhất 2 thẻ"
                            showAlert = true
                            return
                        }
                        courseModel.removeFlashcardViewModel(at: index)
                    }
                }) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Flashcard Input Field for Term
                        FlashcardInputField(
                            text: $courseModel.flashcards[index].term,
                            label: "THUẬT NGỮ",
                            buttonTitle: courseModel.termLanguage?.name?.uppercased() ?? "CHỌN NGÔN NGỮ",
                            onButtonTap: {
                                languageModel.choosingForTerm = true
                                languageModel.openChooseLanguage = true
                            }
                        )

                        // Flashcard Input Field for Definition
                        FlashcardInputField(
                            text: $courseModel.flashcards[index].definition,
                            label: "ĐỊNH NGHĨA",
                            buttonTitle: courseModel.definitionLanguage?.name?.uppercased() ?? "CHỌN NGÔN NGỮ",
                            onButtonTap: {
                                languageModel.choosingForTerm = false
                                languageModel.openChooseLanguage = true
                            }
                        )
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .id(index)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: FlashcardInputField
struct FlashcardInputField: View {
    @Binding var text: String
    var label: String
    var buttonTitle: String
    var onButtonTap: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("", text: $text)
                .padding(5)
                .overlay(
                    Rectangle()
                        .frame(height: 3)
                        .padding(.top, 35)
                        .foregroundColor(.black),
                    alignment: .topLeading
                )
                .padding(.vertical, 10)
                .focused($isFocused)

            HStack(spacing: 12) {
                Text(label)
                    .font(.headline.bold())
                    .foregroundColor(Color("SecondaryColor"))
                
                Spacer()
             
                if isFocused {
                    Button {
                        onButtonTap()
                    } label: {
                        Text(buttonTitle)
                            .font(.headline.bold())
                            .foregroundColor(Color("BlueColor"))
                    }
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut, value: isFocused)
    }
}

// MARK: Swipe Container View
struct SwipeContainerView<Content: View>: View {
    let onDelete: () -> Void
    let content: () -> Content

    @State private var offsetX: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0

    private let deleteAreaWidth: CGFloat = 100

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button(action: {
                    onDelete()

                    // Đóng lại sau khi xóa
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation {
                            offsetX = 0
                        }
                    }
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color("BtnTrashColor"))
                        .clipShape(Circle())
                }
                .padding(.trailing, 20)
            }

            content()
                .offset(x: offsetX + dragOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            if value.translation.width < 0 {
                                state = value.translation.width
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if value.translation.width < -deleteAreaWidth / 2 {
                                    offsetX = -deleteAreaWidth
                                } else {
                                    offsetX = 0
                                }
                            }
                        }
                )
                .onTapGesture {
                    withAnimation {
                        offsetX = 0
                    }
                }
        }
        .animation(.interactiveSpring(), value: offsetX + dragOffset)
    }
}

struct AddCourse_Previews: PreviewProvider {
    static var previews: some View {
        AddCourse()
            .environmentObject(CourseViewModel())
    }
}
