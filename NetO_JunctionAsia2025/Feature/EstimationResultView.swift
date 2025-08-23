import SwiftUI

struct EstimationResultView: View {
    let estimation: EstimationResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("견적 결과")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // 공사 기간
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("예상 공사 기간")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(Int(estimation.durationDays))일")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // 기간별 색상 표시
                    Circle()
                        .fill(durationColor)
                        .frame(width: 12, height: 12)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 예상 비용
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.green)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("예상 공사 비용")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(formatCurrency(estimation.costKRW))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // 평당 단가 계산
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("평당 단가")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(formatCurrency(estimation.costKRW / 34)) // 34평 기준
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // 신뢰도 및 설명
                if let confidence = estimation.confidence {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.orange)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("계산 방식")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(confidence)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                if let explanation = estimation.explanation {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "lightbulb")
                                .foregroundColor(.yellow)
                            Text("참고사항")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        Text(explanation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // 공종별 상세 내역
                if let breakdown = estimation.breakdown {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "list.bullet.clipboard")
                                .foregroundColor(.purple)
                            Text("공종별 상세 내역")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        VStack(spacing: 8) {
                            if let scaffolding = breakdown.scaffolding {
                                BreakdownRow(title: "가설공사", amount: scaffolding, color: .blue)
                            }
                            if let excavation = breakdown.excavation {
                                BreakdownRow(title: "토공사", amount: excavation, color: .brown)
                            }
                            if let piling = breakdown.piling {
                                BreakdownRow(title: "말뚝공", amount: piling, color: .orange)
                            }
                            if let rebar = breakdown.rebar {
                                BreakdownRow(title: "철근공사", amount: rebar, color: .gray)
                            }
                            if let concrete = breakdown.concrete {
                                BreakdownRow(title: "콘크리트공사", amount: concrete, color: .cyan)
                            }
                            if let waterproofing = breakdown.waterproofing {
                                BreakdownRow(title: "방수공사", amount: waterproofing, color: .teal)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            
            // 상세 분석 버튼
            Button(action: {
                // TODO: 상세 분석 뷰로 이동
            }) {
                HStack {
                    Image(systemName: "chart.bar")
                    Text("상세 분석 보기")
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var durationColor: Color {
        let days = estimation.durationDays
        switch days {
        case 0..<30:
            return .green
        case 30..<60:
            return .orange
        default:
            return .red
        }
    }
    
    private func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        if amount >= 10000 {
            let man = Double(amount) / 10000.0
            return "\(formatter.string(from: NSNumber(value: man)) ?? "0")만원"
        } else {
            return "\(formatter.string(from: NSNumber(value: amount)) ?? "0")원"
        }
    }
}

// MARK: - BreakdownRow 컴포넌트
struct BreakdownRow: View {
    let title: String
    let amount: Int
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(formatCurrency(amount))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
    
    private func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        if amount >= 10000 {
            let man = Double(amount) / 10000.0
            return "\(formatter.string(from: NSNumber(value: man)) ?? "0")만원"
        } else {
            return "\(formatter.string(from: NSNumber(value: amount)) ?? "0")원"
        }
    }
}

#Preview {
    EstimationResultView(estimation: EstimationResponse(
        durationDays: 45,
        costKRW: 85000000,
        confidence: "로컬 계산",
        explanation: "표준단가 기반 추정치입니다. ML 모델 연결 후 더 정확한 견적을 받을 수 있습니다.",
        breakdown: nil
    ))
}
