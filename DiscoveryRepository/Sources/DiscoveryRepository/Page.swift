
public struct Page<Data: Equatable, NextPageQuery: Equatable>: Equatable {
    public let data: Data
    public let nextPageQuery: NextPageQuery?

    init(data: Data, nextPageQuery: NextPageQuery) {
        self.data = data
        self.nextPageQuery = nextPageQuery
    }
}
