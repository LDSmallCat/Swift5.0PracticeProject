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
struct DetailStaticModel: Convertible {
    let otherWorks: [OtherWorksModel] = []
    let comic = DetailStaticComicModel()
    let chapter_list: [ChapterModel] = []
}
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
    let theme_ids: [String] = []
    let author = ""
    let comic_id = 0
}

struct AuthorModel: Convertible {
    let avatar = ""
    let id = 0
    let name = ""

}

struct ChapterModel: Convertible {
    let imHightArr: [ImHightModel] = []
    let chapter_id = 0
    let name = ""

}
struct ImHightModel: Convertible {
    let height: CGFloat = 0
    let width: CGFloat = 0
}

struct DetailRealtimeModel: Convertible {
    let comic = ComicDetailModel()
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
