enum NetworkError: Error {
    case urlNotValid
    case noData
    case parsingError
    case notInternet
    case responseError
    case smthWentWrong
    case wrongLoginOrPass
    
    var description: String {
        switch self {
        case .urlNotValid:
            return "Неверный URL изображения"
        case .noData:
            return "Нет данных"
        case .parsingError:
            return "Ошиюка парсинга данных"
        case .notInternet:
            return "Нет интернета"
        case .responseError:
            return "Неверный ответ сервера"
        case .smthWentWrong:
            return "Что-то пошло не так"
        case .wrongLoginOrPass:
            return "Неверный логин или пароль"
        }
    }
}
