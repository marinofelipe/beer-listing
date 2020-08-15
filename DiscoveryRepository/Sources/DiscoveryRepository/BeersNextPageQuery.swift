
public struct BeersNextPageQuery: Equatable {
    var pageIndex: Int

    init(pageIndex: Int) {
        self.pageIndex = pageIndex
    }

    mutating func incrementPage() {
        pageIndex += 1
    }

    public static var initial: BeersNextPageQuery {
        BeersNextPageQuery(pageIndex: 1)
    }
}
