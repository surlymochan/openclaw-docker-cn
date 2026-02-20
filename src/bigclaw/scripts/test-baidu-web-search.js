#!/usr/bin/env node
/**
 * 百度 web_search 接口实际请求测试（与 index.js 中 Baidu 分支一致）
 * 使用方式：在项目根目录执行
 *   BAIDU_API_KEY=xxx node src/bigclaw/scripts/test-baidu-web-search.js
 * 或先加载含 BAIDU_API_KEY 的环境（如 source keys/search.env）再执行
 */
const url = "https://qianfan.baidubce.com/v2/ai_search/web_search";
const payload = {
  messages: [{ role: "user", content: "杭州西湖" }],
  edition: "lite",
  search_source: "baidu_search_v2",
  resource_type_filter: [{ type: "web", top_k: 10 }]
};

const apiKey = process.env.BAIDU_API_KEY;
if (!apiKey) {
  console.error("未设置 BAIDU_API_KEY，请设置后重试");
  process.exit(1);
}

async function main() {
  console.log("请求 URL:", url);
  console.log("请求 body:", JSON.stringify(payload, null, 2));
  const start = Date.now();
  try {
    const res = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${apiKey}`
      },
      body: JSON.stringify(payload)
    });
    const elapsed = Date.now() - start;
    console.log("HTTP 状态:", res.status, res.statusText, "耗时:", elapsed, "ms");
    const data = await res.json();
    if (data.code !== undefined && data.code !== 0) {
      console.log("业务错误:", data.code, data.message);
      process.exit(1);
    }
    const refs = data.references || [];
    console.log("返回 references 条数:", refs.length);
    refs.slice(0, 3).forEach((ref, i) => {
      console.log(`  [${i + 1}] ${ref.title || "无标题"}`);
      console.log(`      ${ref.url || ""}`);
      if (ref.content) console.log(`      ${String(ref.content).slice(0, 80)}…`);
    });
    console.log("测试通过");
  } catch (e) {
    console.error("请求异常:", e.message);
    process.exit(1);
  }
}

main();
