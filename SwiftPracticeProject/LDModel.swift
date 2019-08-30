//
//  LDModel.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

// MARK: - LLCycleScrollViewModel
struct ExtModel: Convertible {
    let key = ""
    let val = ""
 
}
struct GalleryItemModel: Convertible {
 
    let id: Int = 0
    let linkType: Int = 0
    let cover = ""
    let ext: [ExtModel]?
    let title = ""
    let content = ""
    init() { ext = [] }
}

// MARK: - HomeModel
enum comicType: Int, ConvertibleEnum {
    case none = 0
    case update = 3
    case thematic = 5
    case animation = 9
    case billboard = 11
}
struct ComicListModel: Convertible {
    //homePage
    let comics: [ComicModel] = []
    let itemTitle = ""
    let newTitleIconUrl = ""
    let titleIconUrl = ""
    let comicType: comicType = .none

    //VIP
    let argName = ""
    let canMore = false
}
struct ComicModel: Convertible {
    let comicId = 0
    let comic_id = 0
    var cate_id = ""
    let name = ""
    let subTitle = ""
    let cover = ""
    let linkType = 0
    let description = ""
    let short_description = ""
    let author_name = ""

}

struct RankModel: Convertible {
    let subTitle = ""
    let title = ""
    let cover = ""
}

// MARK: - detailStaticModel

struct OtherWorksModel: Convertible{
    let comicId = 0
    let name = ""
    let coverUrl = ""
    let passChapterNum = 0
}
struct DetailStaticComicModel: Convertible {
    let description = ""
    let cover = ""
    let cate_id = ""
    let short_description = ""
    let name = ""
    let classifyTags: [classifyTagsModel] = []
    let author = AuthorModel()
    let comic_id = 0
    let thread_id = 0

}

struct classifyTagsModel: Convertible {
    let argVal = 0
    let argName = ""
    let name = ""

}
struct AuthorModel: Convertible {
    let avatar = ""
    let id = 0
    let name = ""

}
struct DetailStaticModel: Convertible {
    let otherWorks: [OtherWorksModel] = []
    let comic = DetailStaticComicModel()
    let chapter_list: [ChapterModel] = []
}
struct ChapterModel: Convertible {
    let imHightArr: [[ImHightModel]] = []
    let chapter_id = 0
    let name = ""
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        if property.name != "imHightArr" { return jsonValue }
        return (jsonValue as? [[[String:Any]]])?.map {
          return modelArray(from: $0, ImHightModel.self)
        }
    }
//    Cannot convert return expression of type '[_]?' to return type 'Any?'
//    Insert ' as Any?'
//    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
//        if property.name != "imHightArr" { return jsonValue }
//        guard let doubleArray = jsonValue as? [Any] else { return [] }
//
//        var imHightArr = [[ImHightModel]]()
//
//        for element in doubleArray {
//           //数组里面是字典
//           guard let arr = element as? [[String: Any]] else { return [] }
//           //转为数组模型
//           imHightArr.append(modelArray(from: arr, ImHightModel.self))
//        }
//        return imHightArr
//
//    }
}
struct ImHightModel: Convertible {
    let height = 0
    let width = 0
}


struct ComicDetailModel: Convertible {
    let click_total = "0"
    let favorite_total = "0"
    let total_tucao = "0"
    let user_id = 0
    let comic_id = 0
    let comment_total = "0"
    let total_ticket = "0"
    let monthly_ticket = "0"

}

struct ComicCommentListModel: Convertible {
    let commentList: [ComicCommentModel] = []
    let hasMore: Bool = true
    let serverNextPage: Int = 0
   
}
struct ComicCommentModel: Convertible {
    let content = ""
    let content_filter = ""
    let nickname = "0"
    let face = ""
    
    var cellHeight: CGFloat = 60
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        let h = content.getHeightFor(13, ceil(screenWidth - 70)) + 45
        cellHeight = h > cellHeight ? h : cellHeight
    }
    
    
}
