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
    
    
    
    var body: some View {
        VStack{
            header()
            
            Divider()
        }
        
//        VStack{
//            Button (action: {
//                dismiss()
//            }, label: {
//                Image(systemName: "arrow.left")
//                    .font(.title3.bold())
//                    .foregroundStyle(Color("SmallTitleColor"))
//            })
//            Text(courseModel.courseTitle)
//
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
        ZStack {
            Color.white
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3.bold())
                        .foregroundStyle(Color("SmallTitleColor"))
                }
                
                Spacer()
                
                Text(courseModel.selectedCourse?.title ?? "Course Detail")
                    .font(.title2.bold())
                
                Spacer()
                
                Button {
                    // Display setting
                } label: {
                    Image(systemName: "gearshape")
                        .font(.title3.bold())
                        .foregroundStyle(Color("SmallTitleColor"))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
        .frame(height: 60)
    }
}

struct CourseDetail_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetail()
            .environmentObject(CourseViewModel())
    }
}
