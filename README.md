# DwPupu

    仿朴朴

## 环境

    * swift5
    * rxswift 4.4
    * Alamofire 4.8

## API开关

    ```

        struct PupuApi: PupuAPIProtocol {

            // 使用本地缓存的API response
            private static let isLocal = true

            // 使用朴朴远程接口，由于朴朴业务更新，不保证长期有效
            // private static let isLocal = true


            // ...

        }

    ```
