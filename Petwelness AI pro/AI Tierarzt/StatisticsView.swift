//
//  StatisticsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var petManager = PetManager()
    @StateObject private var healthRecordManager = HealthRecordManager()
    
    var totalPets: Int {
        petManager.pets.count
    }
    
    var totalMedications: Int {
        healthRecordManager.medications.filter { $0.isActive }.count
    }
    
    var totalVaccinations: Int {
        healthRecordManager.vaccinations.count
    }
    
    var totalAppointments: Int {
        healthRecordManager.appointments.filter { $0.date > Date() && !$0.isCompleted }.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                if totalPets == 0 {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: Spacing.xl) {
                            // Overview Cards
                            overviewCards
                                .padding(.top, Spacing.lg)
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationTitle("statistics.title".localized)
                .id(localizationManager.currentLanguage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.brandPrimary)
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Color.backgroundSecondary)
                    .frame(width: 80, height: 80)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.accentGreen)
                            .frame(width: 12, height: 30)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.accentRed)
                            .frame(width: 12, height: 20)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.accentBlue)
                            .frame(width: 12, height: 40)
                    }
                }
            }
            
            Text("statistics.noData".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("statistics.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
    
    private var overviewCards: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: Spacing.md),
            GridItem(.flexible(), spacing: Spacing.md)
        ], spacing: Spacing.md) {
            StatCard(
                icon: "pawprint.fill",
                iconColor: .brandPrimary,
                title: "statistics.pets".localized,
                value: "\(totalPets)",
                subtitle: totalPets == 1 ? "statistics.pet".localized : "statistics.pets".localized,
                localizationManager: localizationManager
            )
            
            StatCard(
                icon: "pills.fill",
                iconColor: .accentOrange,
                title: "statistics.medications".localized,
                value: "\(totalMedications)",
                subtitle: "statistics.active".localized,
                localizationManager: localizationManager
            )
            
            StatCard(
                icon: "calendar",
                iconColor: .accentBlue,
                title: "statistics.vaccinations".localized,
                value: "\(totalVaccinations)",
                subtitle: "statistics.total".localized,
                localizationManager: localizationManager
            )
            
            StatCard(
                icon: "calendar.badge.clock",
                iconColor: .accentPurple,
                title: "statistics.appointments".localized,
                value: "\(totalAppointments)",
                subtitle: "statistics.upcoming".localized,
                localizationManager: localizationManager
            )
        }
    }
    
}

struct StatCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let subtitle: String
    let localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(iconColor)
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .id(localizationManager.currentLanguage)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
            
            Text(subtitle)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
}




