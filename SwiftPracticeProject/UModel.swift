//
//  UModel.swift
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
    let ext: [ExtModel] = []
    let title = ""
    let content = ""
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
    var argCon: Int = 0
    var argValue: Int = 0
    //VIP
    let argName = ""
    let canMore = false
}
struct MoreComicModel: Convertible {
    let page = 1
    let hasMore = true
    let comics: [ComicModel] = []
}
struct ComicModel: Convertible {
    let comicId = 0
    let comic_id = 0
    var cate_id = ""
    let name = ""
    let title = ""
    let subTitle = ""
    let cover = ""
    let linkType = 0
    let description = ""
    let short_description = ""
    let author_name = ""
    let tags: [String] = []
    let author = ""
    let specialType: Int = 0
    let specialId: Int = 0
    let ext: [ExtModel] = []

    let conTag = 0
    let argValue = 0
    let argCon = 0
    let argName = ""

    let isComment = false
    var clickTag = 0
    var tagString = ""
    var clickString = ""
    
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        clickTag = conTag
        let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(conTag)))
        
        if comicDate < 60 {
            tagString = "\(Int(comicDate))秒前"
        } else if comicDate < 3600 {
            tagString = "\(Int(comicDate / 60))分前"
        } else if comicDate < 86400 {
            tagString = "\(Int(comicDate / 3600))小时前"
        } else if comicDate < 31536000{
            tagString = "\(Int(comicDate / 86400))天前"
        } else {
            tagString = "\(Int(comicDate / 31536000))年前"
        }
        
        
        if clickTag > 100000000 {
            clickString = String(format: "%.1f亿", Double(clickTag) / 100000000)
        } else if clickTag > 10000 {
            clickString = String(format: "%.1f万", Double(clickTag) / 10000)
        }else {
            clickString = "\(clickTag)"
        }
        
    }
}

struct RankModel: Convertible {
    let subTitle = ""
    let title = ""
    let cover = ""
    let argCon = 0
    let argName = ""
    let argValue = 0

}
struct SearchHotModel: Convertible {
    let comic_id = 0
    let name = ""
    let bgColor = ""
    var cellWidth: CGFloat = 80
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        
       cellWidth = name.getWidthFor(14) + 40
   }
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
    let last_update_time: TimeInterval = 0
    
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
//
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
