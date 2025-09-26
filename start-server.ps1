# 简单的HTTP服务器启动脚本
$port = 8000
Write-Host "启动HTTP服务器在端口 $port..."
Write-Host "请在浏览器中访问 http://localhost:$port"

# 创建HTTP监听器
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://*:$port/")
$listener.Start()

# 处理请求的函数
function Handle-Request($context) {
    $request = $context.Request
    $response = $context.Response
    
    try {
        # 获取请求的文件路径
        $filePath = Join-Path -Path $PSScriptRoot -ChildPath ($request.Url.LocalPath -replace '^/', '')
        
        # 如果路径为空，默认加载index.html
        if ($filePath -eq $PSScriptRoot) {
            $filePath = Join-Path -Path $PSScriptRoot -ChildPath "index.html"
        }
        
        # 检查文件是否存在
        if (Test-Path -Path $filePath -PathType Leaf) {
            # 读取文件内容
            $content = Get-Content -Path $filePath -Raw
            
            # 设置Content-Type
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = switch ($extension) {
                '.html' { 'text/html' }
                '.js' { 'application/javascript' }
                '.css' { 'text/css' }
                '.json' { 'application/json' }
                '.png' { 'image/png' }
                '.jpg' { 'image/jpeg' }
                '.svg' { 'image/svg+xml' }
                default { 'application/octet-stream' }
            }
            
            $response.ContentType = $contentType
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        } else {
            # 文件不存在，返回404
            $response.StatusCode = 404
            $content = "404 - 文件未找到"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
    } catch {
        # 处理异常
        $response.StatusCode = 500
        $content = "500 - 服务器错误: $($_.Exception.Message)"
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
    } finally {
        $response.OutputStream.Close()
        $context.Response.Close()
    }
}

# 主循环
while ($listener.IsListening) {
    $context = $listener.GetContextAsync().Result
    
    # 使用后台作业处理请求
    Start-Job -ScriptBlock { param($ctx) Handle-Request $ctx } -ArgumentList $context | Out-Null
}

# 停止服务器的方法（按Ctrl+C中断）
Write-Host "按Ctrl+C停止服务器..."