//
//  Library.swift
//  Project
//
//  Created by  User on 04.05.2025.
//

import SwiftUI

struct Library: View {
    @StateObject var courseModel = CourseViewModel()
    
    private let tabs = [ "Học phần", "Thư mục" ]
    
    @State private var selectedTab = 0
    @State private var isPressed = false
    @State private var filterText: String = ""
    
    @FocusState private var isFocused: Bool
   
    // MARK: Fetching Course
    @FetchRequest(entity: Course.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Course.createdAt, ascending: false)], predicate: nil, animation: .easeInOut) var courses: FetchedResults<Course>
    
    var body: some View {
        VStack(){
            HeaderView()
            TabBarView()
            
            if selectedTab == 0{
                CoursesView()
            } else if selectedTab == 1{
                FoldersView()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $courseModel.openAddCourse){
            AddCourse()
                .environmentObject(courseModel)
        }.fullScreenCover(isPresented: $courseModel.openCourseDetail){
            CourseDetail()
                .environmentObject(courseModel)
        }
    }
    
    // MARK: Header
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Text("Thư viện")
                .font(.title.bold())

            Spacer()

            Button(action: {
                // MARK: Add Button
                courseModel.openAddCourse.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(Color("SmallTitleColor"))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(isPressed ? Color.gray.opacity(0.2) : Color.clear)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPressed = false
                        }
                    }
            )
        }
        .padding(.bottom, 50)
    }
    
    // MARK: Tab Bar
    @ViewBuilder
    private func TabBarView() -> some View {
        VStack(alignment: .leading, spacing: 4){
            HStack(spacing: 16) {
                ForEach(tabs.indices, id: \.self) { index in
                    Button(action: {
                        selectedTab = index
                    }) {
                        VStack(spacing: 4){
                            Text(tabs[index])
                                .fontWeight(selectedTab == index ? .bold : .regular)
                                .foregroundColor(selectedTab == index ? .black : Color("SmallTitleColor"))
                        }
                    }
                    .padding(.bottom, 5)
                    Spacer()
                }
            }
            
            // MARK: Gạch dưới tab
            GeometryReader { geometry in
                Rectangle()
                    .fill(.blue)
                    .frame(width: geometry.size.width / CGFloat(tabs.count), height: 3)
                    .offset(x: geometry.size.width / CGFloat(tabs.count) * CGFloat(selectedTab))
                    .animation(.easeOut(duration: 0.3), value: selectedTab)
            }
            .frame(height: 2)
        }
        .padding(.bottom, 20)
    }
    
    // MARK: Filter
    @ViewBuilder
    private func FilterView() -> some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Text("Tìm kiếm")
                    .scaleEffect((isFocused || !filterText.isEmpty) ? 0.8 : 1.0, anchor: .leading)
                    .offset(y: (isFocused || !filterText.isEmpty) ? -22 : 0)
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.2), value: isFocused || !filterText.isEmpty)

                TextField("", text: $filterText)
                    .focused($isFocused)
                    .padding(5)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .padding(.top, 35),
                        alignment: .topLeading
                    )
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: Course Card
    @ViewBuilder
    private func CourseCardView(course: Course) -> some View {
        Button(action:{
            courseModel.selectedCourse = course
            courseModel.openCourseDetail = true
        }) {
            VStack(alignment: .leading) {
                Text(course.title ?? "")
                    .font(.title3)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.bottom, 20)
                
                let flashcardCount = course.flashcards.count
                Text("\(flashcardCount) thuật ngữ")
                    .foregroundColor(Color("SmallTitleColor")) 
                    .bold()
                    .font(.headline)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderColor"), lineWidth: 5)
            )
            .cornerRadius(10)
            .padding(.bottom, 15)
        }
    }
    
    // MARK: Courses View
    @ViewBuilder
    private func CoursesView() -> some View{
        ScrollView {
            FilterView()

            ForEach(courses.filter{
                // Nếu filterText rỗng thì không lọc, trả lại tất cả courses
                filterText.isEmpty ||
                
                // Nếu filterText không rỗng, chỉ giữ các Course có title chứa filterText (không phân biệt hoa thường)
                $0.title?.localizedCaseInsensitiveContains(filterText) == true
            }){ course in
                CourseCardView(course: course)
            }
        }
        .padding(.top ,20)
    }
    
    // MARK: Folders View
    @ViewBuilder
    private func FoldersView() -> some View{
        ScrollView {
            FolderCardView(title: "Từ vựng TOEIC", courseCount: 5)
            FolderCardView(title: "Từ vựng N4", courseCount: 3)
        }
    }
    
    // MARK: Folder Card
    @ViewBuilder
    private func FolderCardView(title: String, courseCount: Int) -> some View {
        VStack(alignment: .leading) {
            HStack{
                Image(systemName: "folder")
                    .foregroundColor(Color("SmallTitleColor"))
                    .font(.title2)
                    .bold()
                
                Text(title)
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 10)
            }
            .padding(.bottom, 15)
            
            Text("\(courseCount) học phần")
                .font(.headline)
                .bold()
                .foregroundColor(Color("SmallTitleColor"))
        }
        .padding(25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderColor"), lineWidth: 5)
        )
        .cornerRadius(10)
        .padding(.bottom, 15)
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
