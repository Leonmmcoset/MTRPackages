// 生成资源包列表的JavaScript
function generateResourceList() {
    const container = document.getElementById('resource-list');
    if (!container || !resourcePackages) {
        return;
    }
    
    // 清空容器
    container.innerHTML = '';
    
    // 遍历资源包数据
    resourcePackages.forEach(pkg => {
        const card = document.createElement('div');
        card.className = 'border rounded p-4 mb-4 bg-white shadow-sm';
        
        // 资源包名称
        const nameElement = document.createElement('h3');
        nameElement.className = 'text-xl font-bold mb-2';
        nameElement.textContent = pkg.name;
        card.appendChild(nameElement);
        
        // 资源包信息
        const infoContainer = document.createElement('div');
        infoContainer.className = 'mb-3 text-sm text-gray-600';
        
        // 是否付费
        const paidElement = document.createElement('span');
        paidElement.className = pkg.isPaid ? 'text-red-600 font-medium' : 'text-green-600 font-medium';
        paidElement.textContent = pkg.isPaid ? '付费资源' : '免费资源';
        infoContainer.appendChild(paidElement);
        infoContainer.appendChild(document.createTextNode(' | '));
        
        // 开放协议
        const licenseElement = document.createElement('span');
        licenseElement.textContent = `协议: ${pkg.license}`;
        infoContainer.appendChild(licenseElement);
        
        card.appendChild(infoContainer);
        
        // 下载链接
        const downloadButton = document.createElement('a');
        downloadButton.href = pkg.downloadUrl;
        downloadButton.className = 'inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors';
        downloadButton.textContent = '下载资源包';
        downloadButton.target = '_blank';
        
        card.appendChild(downloadButton);
        container.appendChild(card);
    });
}

// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', generateResourceList);