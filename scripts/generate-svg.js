#!/usr/bin/env node

/**
 * SVG図表生成スクリプト
 * 使用法: node scripts/generate-svg.js
 */

import { JSDOM } from 'jsdom';
import * as d3 from 'd3';
import fs from 'fs';
import path from 'path';

// DOMセットアップ
const dom = new JSDOM('<!DOCTYPE html><html><body></body></html>');
global.document = dom.window.document;
global.window = dom.window;

// D3のSVG生成関数
function generateTechDiagram() {
  // データ定義
  const layers = [
    {
      name: "クラウド層",
      y: 80,
      height: 100,
      color: "#e3f2fd",
      stroke: "#1976d2",
      boxes: [
        { name: "汎用プラットフォーム型", detail: "(AWS IoT, Azure IoT)", x: 50, width: 300 },
        { name: "産業プラットフォーム型", detail: "(Siemens MindSphere)", x: 400, width: 300 }
      ]
    },
    {
      name: "通信層",
      y: 220,
      height: 100,
      color: "#f3e5f5",
      stroke: "#7b1fa2",
      boxes: [
        { name: "汎用通信インフラ型", detail: "(5G MEC, CDN)", x: 50, width: 300 },
        { name: "産業通信統合型", detail: "(ローカル5G, TSN)", x: 400, width: 300 }
      ]
    },
    {
      name: "エッジ処理層",
      y: 360,
      height: 100,
      color: "#e8f5e8",
      stroke: "#388e3c",
      boxes: [
        { name: "エッジAI", detail: "(推論・学習)", x: 50, width: 180 },
        { name: "ゲートウェイ", detail: "(プロトコル変換)", x: 260, width: 180 },
        { name: "エッジ分析", detail: "(リアルタイム処理)", x: 470, width: 230 }
      ]
    },
    {
      name: "デバイス層",
      y: 500,
      height: 100,
      color: "#fff3e0",
      stroke: "#f57c00",
      boxes: [
        { name: "汎用デバイス連携型", detail: "(IoTセンサー)", x: 50, width: 300 },
        { name: "産業特化統合型", detail: "(FA機器, 車載系)", x: 400, width: 300 }
      ]
    }
  ];

  // SVG作成
  const width = 800;
  const height = 650;
  const svg = d3.select(document.body)
    .append("svg")
    .attr("width", width)
    .attr("height", height)
    .attr("viewBox", `0 0 ${width} ${height}`)
    .attr("xmlns", "http://www.w3.org/2000/svg")
    .style("font-family", "system-ui, sans-serif")
    .style("background", "white");

  // 矢印マーカーの定義
  const defs = svg.append("defs");
  defs.append("marker")
    .attr("id", "arrowhead")
    .attr("viewBox", "0 -5 10 10")
    .attr("refX", 8)
    .attr("refY", 0)
    .attr("orient", "auto")
    .attr("markerWidth", 6)
    .attr("markerHeight", 6)
    .append("path")
    .attr("d", "M0,-5L10,0L0,5")
    .attr("fill", "#555");

  // 層の描画
  layers.forEach(layer => {
    // 層の背景
    svg.append("rect")
      .attr("x", 30)
      .attr("y", layer.y)
      .attr("width", width - 60)
      .attr("height", layer.height)
      .attr("fill", layer.color)
      .attr("stroke", layer.stroke)
      .attr("stroke-width", 2)
      .attr("rx", 8);

    // 層のタイトル
    svg.append("text")
      .attr("x", width / 2)
      .attr("y", layer.y + 25)
      .attr("text-anchor", "middle")
      .attr("font-size", "16px")
      .attr("font-weight", "bold")
      .attr("fill", "#333")
      .text(layer.name);

    // 技術ボックスの描画
    layer.boxes.forEach(box => {
      // ボックス
      svg.append("rect")
        .attr("x", box.x)
        .attr("y", layer.y + 40)
        .attr("width", box.width)
        .attr("height", 45)
        .attr("fill", "white")
        .attr("stroke", layer.stroke)
        .attr("stroke-width", 1)
        .attr("rx", 4);

      // メインテキスト
      svg.append("text")
        .attr("x", box.x + box.width / 2)
        .attr("y", layer.y + 58)
        .attr("text-anchor", "middle")
        .attr("font-size", "12px")
        .attr("font-weight", "600")
        .attr("fill", "#333")
        .text(box.name);

      // 詳細テキスト
      svg.append("text")
        .attr("x", box.x + box.width / 2)
        .attr("y", layer.y + 74)
        .attr("text-anchor", "middle")
        .attr("font-size", "10px")
        .attr("fill", "#666")
        .text(box.detail);
    });
  });

  // 縦方向矢印
  const verticalArrows = [
    { from: [200, 490], to: [200, 470] },
    { from: [550, 490], to: [550, 470] },
    { from: [200, 350], to: [200, 330] },
    { from: [550, 350], to: [550, 330] },
    { from: [200, 210], to: [200, 190] },
    { from: [550, 210], to: [550, 190] }
  ];

  verticalArrows.forEach(arrow => {
    svg.append("line")
      .attr("x1", arrow.from[0])
      .attr("y1", arrow.from[1])
      .attr("x2", arrow.to[0])
      .attr("y2", arrow.to[1])
      .attr("stroke", "#555")
      .attr("stroke-width", 2)
      .attr("marker-end", "url(#arrowhead)");
  });

  // 横方向連携線
  layers.forEach(layer => {
    if (layer.boxes.length === 2) {
      const yPos = layer.y + layer.height + 10;
      const centerX = (layer.boxes[0].x + layer.boxes[0].width / 2 + layer.boxes[1].x + layer.boxes[1].width / 2) / 2;

      // 点線
      svg.append("line")
        .attr("x1", layer.boxes[0].x + layer.boxes[0].width / 2)
        .attr("y1", yPos)
        .attr("x2", layer.boxes[1].x + layer.boxes[1].width / 2)
        .attr("y2", yPos)
        .attr("stroke", "#999")
        .attr("stroke-width", 1)
        .attr("stroke-dasharray", "3,3");

      // 双方向矢印
      svg.append("text")
        .attr("x", centerX)
        .attr("y", yPos + 4)
        .attr("text-anchor", "middle")
        .attr("font-size", "12px")
        .attr("fill", "#777")
        .text("⟷");
    }
  });

  return svg.node().outerHTML;
}

// メイン処理
function main() {
  try {
    console.log('SVG図表を生成中...');

    const svgContent = generateTechDiagram();
    const outputPath = path.join(process.cwd(), 'reports/images/tech-diagram.svg');

    // ディレクトリが存在しない場合は作成
    const outputDir = path.dirname(outputPath);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    // SVGファイル保存
    fs.writeFileSync(outputPath, svgContent, 'utf8');

    console.log(`✅ SVGファイルが生成されました: ${outputPath}`);

  } catch (error) {
    console.error('❌ SVG生成エラー:', error);
    process.exit(1);
  }
}

// 実行
main();